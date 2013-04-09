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
        if enabled?
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

      def enabled?
        enabled_swapfiles = shell_out("swapon --summary").stdout
        swapfile_regex = Regexp.new("^#{@new_resource.path}\\s+")
        ! swapfile_regex.match(enabled_swapfiles).nil?
      end

    end
  end
end