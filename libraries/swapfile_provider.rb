#
# Copyright 2012-2014, Seth Vargo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'fileutils'
require 'chef/mixin/shell_out'

class Chef
  class Provider
    class SwapFile < Chef::Provider
      include Chef::Mixin::ShellOut

      def load_current_resource
        @current_resource ||= Chef::Resource::SwapFile.new(new_resource.name)
        @current_resource.path(new_resource.path)
        @current_resource.size(new_resource.size)
        @current_resource.persist(!!new_resource.persist)
        @current_resource
      end

      def action_create
        command = swap_creation_command
        fallback_command = fallback_swap_creation_command
        if swap_enabled?
          Chef::Log.debug("#{@new_resource} already created - nothing to do")
        else
          begin
            do_create(command)
          rescue Mixlib::ShellOut::ShellCommandFailed => e
            Chef::Log.info("#{@new_resource} Rescuing failed swapfile creation for #{@new_resource.path}")
            Chef::Log.debug("#{@new_resource} Exception when creating swapfile #{@new_resource.path}: #{e}")
            do_create(fallback_command)
          end
        end
      end

      def action_remove
        swapoff
        remove_swapfile
      end

      protected

      def do_create(command)
        create_swapfile(command)
        set_permissions
        mkswap
        swapon
        persist if persist?
      end

      def create_swapfile(command)
        shell_out!(command)
        Chef::Log.info("#{@new_resource} Creating empty file at #{@new_resource.path}")
        Chef::Log.debug("#{@new_resource} Empty file at #{@new_resource.path} created using command '#{command}'")
      end

      def set_permissions
        permissions = '600'
        shell_out!("chmod #{permissions} #{@new_resource.path}")
        Chef::Log.info("#{@new_resource} Set permissions on #{@new_resource.path} to #{permissions}")
      end

      def mkswap
        shell_out!("mkswap -f #{@new_resource.path}")
        Chef::Log.info("#{@new_resource} #{@new_resource.path} made swappable")
      end

      def swapon
        shell_out!("swapon #{@new_resource.path}")
        Chef::Log.info("#{@new_resource} Swap enabled for #{@new_resource.path}")
      end

      def swapoff
        shell_out!("swapoff #{@new_resource.path}")
        Chef::Log.info("#{@new_resource} Swap disabled for #{@new_resource.path}")
      end

      def remove_swapfile
        ::FileUtils.rm(@new_resource.path)
        Chef::Log.info("#{@new_resource} Removing swap file at #{@new_resource.path}")
      end

      def swap_enabled?
        enabled_swapfiles = shell_out('swapon --summary').stdout
        # Regex for our resource path and only our resource path
        # It will terminate on whitespace after the path it match
        # /testswapfile would match
        # /testswapfiledir/someotherfile will not
        swapfile_regex = Regexp.new("^#{@new_resource.path}[\\s\\t\\n\\f]+")
        !swapfile_regex.match(enabled_swapfiles).nil?
      end

      def swap_creation_command
        if compatible_filesystem? && compatible_kernel
          command = fallocate_command
        else
          command = dd_command
        end
        Chef::Log.debug("#{@new_resource} swap creation command is '#{command}'")
        command
      end

      def fallback_swap_creation_command
        command = dd_command
        Chef::Log.debug("#{@new_resource} fallback swap creation command is '#{command}'")
        command
      end

      # The block size (1MB)
      def block_size
        1_048_576
      end

      def fallocate_size
        size = block_size * @new_resource.size
        Chef::Log.debug("#{@new_resource} fallocate size is #{size}")
        size
      end

      def fallocate_command
        size = fallocate_size
        command = "fallocate -l #{size} #{@new_resource.path}"
        Chef::Log.debug("#{@new_resource} fallocate command is '#{command}'")
        command
      end

      def dd_command
        command = "dd if=/dev/zero of=#{@new_resource.path} bs=#{block_size} count=#{@new_resource.size}"
        Chef::Log.debug("#{@new_resource} dd command is '#{command}'")
        command
      end

      def compatible_kernel
        fallocate_location = shell_out('which fallocate').stdout
        Chef::Log.debug("#{@new_resource} fallocate location is '#{fallocate_location}'")
        ::File.exist?(fallocate_location.chomp)
      end

      def compatible_filesystem?
        compatible_filesystems = %w(xfs ext4)
        parent_directory = ::File.dirname(@new_resource.path)
        # Get FS info, get second line as first is column headings
        command = "df -T #{parent_directory} | awk 'NR==2 {print $2}'"
        result = shell_out(command).stdout
        Chef::Log.debug("#{@new_resource} filesystem listing is '#{result}'")
        compatible_filesystems.any? { |fs| result.include? fs }
      end

      def persist?
        !!@new_resource.persist
      end

      def persist
        fstab = '/etc/fstab'
        contents = ::File.readlines(fstab)
        addition = "#{@new_resource.path} swap swap defaults 0 0"

        if contents.any? { |line| line.strip == addition }
          Chef::Log.debug("#{@new_resource} already added to /etc/fstab - skipping")
        else
          Chef::Log.info("#{@new_resource} adding entry to #{fstab} for #{@new_resource.path}")

          contents << "#{addition}\n"
          ::File.open(fstab, 'w') { |f| f.write(contents.join('')) }
        end
      end
    end
  end
end
