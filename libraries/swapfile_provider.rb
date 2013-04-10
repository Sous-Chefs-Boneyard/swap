require 'chef/mixin/shell_out'

class Chef
  class Provider
    class SwapFile < Chef::Provider

      include Chef::Mixin::ShellOut

      def load_current_resource
        @current_resource ||= Chef::Resource::SwapFile.new(new_resource.name)
        @current_resource.path(new_resource.path)
        @current_resource.size(new_resource.size)
        @current_resource
      end

      def action_create
        command = swap_creation_command(@new_resource)
        fallback_command = fallback_swap_creation_command(@new_resource)
        if swap_enabled?
          Chef::Log.debug("#{@new_resource} already created - nothing to do")
        else
          begin
            create_swapfile(command)
            set_permissions
            mkswap
            swapon  
          rescue Mixlib::ShellOut::ShellCommandFailed => e
            Chef::Log.info("#{@new_resource} Rescuing failed swapfile creation for #{@new_resource.path}")
            Chef::Log.debug("#{@new_resource} Exception when creating swapfile #{@new_resource.path}: #{e}")
            create_swapfile(fallback_command)
            set_permissions
            mkswap
            swapon
          end
        end
      end

      def action_remove
        swapoff
        remove_swapfile
      end

      protected

        def create_swapfile(command)
          shell_out!(command)
          Chef::Log.info("#{@new_resource} Creating empty file at #{@new_resource.path}")
          Chef::Log.debug("#{@new_resource} Empty file at #{@new_resource.path} created using command '#{command}'")
        end

        def set_permissions
          permissions = "600"
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
          enabled_swapfiles = shell_out("swapon --summary").stdout
          # Regex for our resource path and only our resource path
          # It will terminate on whitespace after the path it match
          # /testswapfile would match
          # /testswapfiledir/someotherfile will not
          swapfile_regex = Regexp.new("^#{@new_resource.path}[\\s\\t\\n\\f]+")
          ! swapfile_regex.match(enabled_swapfiles).nil?
        end

        def swap_creation_command(nr)
          if compatible_filesystem?(nr) && compatible_kernel(nr)
            command = get_fallocate_command(nr)
          else
            command = get_dd_command(nr)
          end
          Chef::Log.debug("#{nr} swap creation command is '#{command}'")
          command
        end

        def fallback_swap_creation_command(nr)
          command = get_dd_command(nr)
          Chef::Log.debug("#{nr} fallback swap creation command is '#{command}'")
          command
        end

        # The block size (1MB)
        def block_size
          1048576
        end

        def get_fallocate_size(nr)
          size = block_size * nr.size
          Chef::Log.debug("#{nr} fallocate size is #{size}")
          size
        end

        def get_fallocate_command(nr)
          size = get_fallocate_size(nr)
          command = "fallocate -l #{size} #{nr.path}"
          Chef::Log.debug("#{nr} fallocate command is '#{command}'")
          command
        end

        def get_dd_command(nr)
          command = "dd if=/dev/zero of=#{nr.path} bs=#{block_size} count=#{nr.size}"
          Chef::Log.debug("#{nr} dd command is '#{command}'")
          command
        end

        def compatible_kernel(nr)
          fallocate_location = %x[which fallocate]
          Chef::Log.debug("#{nr} fallocate location is '#{fallocate_location}'")
          ::File.exists?(fallocate_location.chomp)
        end

        def compatible_filesystem?(nr)
          compatible_filesystems = ['xfs', 'ext4']
          parent_directory = ::File.dirname(nr.path)
          # Get FS info, get second line as first is column headings
          command = "df -T #{parent_directory} | awk 'NR==2 {print $2}'"
          result = %x[#{command}]
          Chef::Log.debug("#{nr} filesystem listing is '#{result}'")
          compatible_filesystems.any? { |fs| result.include? fs }
        end

    end
  end
end