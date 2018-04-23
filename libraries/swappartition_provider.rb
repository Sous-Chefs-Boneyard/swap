# encoding: utf-8

require 'fileutils'
require 'chef/mixin/shell_out'

#
class Chef
  #
  class Provider
    # Use a partition as swap space.
    class SwapPartition < Chef::Provider
      include Chef::Mixin::ShellOut
      provides:swap_partition

      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.name)
        @current_resource.path(new_resource.path)
        @current_resource.persist(new_resource.persist)
        @current_resource
      end

      def action_create
        if swap_enabled?
          Chef::Log.debug("#{@new_resource} already created - nothing to do")
        else
          do_create
        end
      end

      def action_remove
        swapoff
        remove_swapfile
      end

      protected

      def do_create
        mkswap
        swapon
        persist if persist?
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
        # It will terminate on whitespace after the path it matchs
        # /testswapfile would match
        # /testswapfiledir/someotherfile will not
        #
        # Also looke for /dev/dm-xx internal name if the path used is a symbolic line
        # The check for realpath checks for an alias used in rhel6
        swapfile_regex = Regexp.new("^(#{@new_resource.path}|#{Pathname.new(@new_resource.path).realpath})[\\s\\t\\n\\f]+")
        Chef::Log.debug("#{@new_resource} checking for swap files at #{@new_resource.path} and at #{Pathname.new(@new_resource.path).realpath}")
        !swapfile_regex.match(enabled_swapfiles).nil?
      end

      def persist?
        @new_resource.persist
      end

      def persist
        fstab = '/etc/fstab'
        contents = ::File.readlines(fstab)
        addition = "#{@new_resource.path} swap swap defaults 0 0"

        if contents.any? { |line| line.strip == addition }
          Chef::Log.debug("#{@new_resource} already added to /etc/fstab -
            skipping")
        else
          Chef::Log.info("#{@new_resource} adding entry to #{fstab} for
            #{@new_resource.path}")

          contents << "#{addition}\n"
          ::File.open(fstab, 'w') { |f| f.write(contents.join('')) }
        end
      end
    end
  end
end
