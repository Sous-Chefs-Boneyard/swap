module SwapCookbook
  module Helpers
    def do_create(command)
      create_swapfile(command)
      set_permissions
      mkswap
      swapon
      persist_swap if persist?
    end

    def create_swapfile(command)
      converge_by "create empty swapfile at #{new_resource.path}" do # ~FC005
        shell_out!(command, timeout: new_resource.timeout)
      end
    end

    def set_permissions
      permissions = 600
      converge_by "set permissions on #{new_resource.path} to #{permissions}" do
        shell_out!("chmod #{permissions} #{new_resource.path}")
      end
    end

    def mkswap
      converge_by "make #{new_resource.path} swappable" do
        shell_out!("mkswap -f #{new_resource.path}")
      end
    end

    def swapon
      converge_by "enable swap for #{new_resource.path}" do
        shell_out!("swapon #{new_resource.path}")
      end
    end

    def swapoff
      converge_by "turn off swap for #{new_resource.path}" do
        shell_out!("swapoff #{new_resource.path}")
      end
    end

    def remove_swapfile
      converge_by "remove swap file #{new_resource.path}" do
        ::FileUtils.rm(new_resource.path)
      end
    end

    def swap_enabled?
      enabled_swapfiles = shell_out('swapon --summary').stdout
      # Regex for our resource path and only our resource path
      # It will terminate on whitespace after the path it match
      # /testswapfile would match
      # /testswapfiledir/someotherfile will not
      swapfile_regex = Regexp.new("^#{new_resource.path}[\\s\\t\\n\\f]+")
      !swapfile_regex.match(enabled_swapfiles).nil?
    end

    def swap_creation_command
      command = if compatible_filesystem? && compatible_kernel && !docker?
                  fallocate_command
                else
                  dd_command
                end
      Chef::Log.debug("#{new_resource} swap creation command is '#{command}'")
      command
    end

    def fallback_swap_creation_command
      command = dd_command
      Chef::Log.debug("#{new_resource} fallback swap creation command is '#{command}'")
      command
    end

    # The block size (1MB)
    def block_size
      1_048_576
    end

    def fallocate_size
      size = block_size * new_resource.size
      Chef::Log.debug("#{new_resource} fallocate size is #{size}")
      size
    end

    def fallocate_command
      size = fallocate_size
      command = "fallocate -l #{size} #{new_resource.path}"
      Chef::Log.debug("#{new_resource} fallocate command is '#{command}'")
      command
    end

    def dd_command
      command = "dd if=/dev/zero of=#{new_resource.path} bs=#{block_size} count=#{new_resource.size}"
      Chef::Log.debug("#{new_resource} dd command is '#{command}'")
      command
    end

    def compatible_kernel
      fallocate_location = shell_out('which fallocate').stdout
      Chef::Log.debug("#{new_resource} fallocate location is '#{fallocate_location}'")
      ::File.exist?(fallocate_location.chomp)
    end

    def compatible_filesystem?
      compatible_filesystems = %w(xfs ext4)
      parent_directory = ::File.dirname(new_resource.path)
      # Get FS info, get second line as first is column headings
      command = "df -PT #{parent_directory} | awk 'NR==2 {print $2}'"
      result = shell_out(command).stdout
      Chef::Log.debug("#{new_resource} filesystem listing is '#{result}'")
      compatible_filesystems.any? { |fs| result.include? fs }
    end

    # we can remove this when we only support Chef 13
    def docker?(node = run_context.nil? ? nil : run_context.node)
      !!(node && node['virtualization'] && node['virtualization']['systems'] &&
         node['virtualization']['systems']['docker'] && node['virtualization']['systems']['docker'] == 'guest')
    end

    def persist?
      new_resource.persist
    end

    def persist_swap
      fstab = '/etc/fstab'
      contents = ::File.readlines(fstab)
      addition = "#{new_resource.path} swap swap defaults 0 0"

      if contents.any? { |line| line.strip == addition }
        Chef::Log.debug("#{new_resource} already added to #{fstab} - skipping")
      else
        Chef::Log.info("#{new_resource} adding entry to #{fstab} for #{new_resource.path}")

        contents << "#{addition}\n"
        ::File.open(fstab, 'w') { |f| f.write(contents.join('')) }
      end
    end
  end
end
