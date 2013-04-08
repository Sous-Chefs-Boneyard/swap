require 'chef/mixin/shell_out'

class Chef
  class Provider
    class Swap < Chef::Provider

      include Chef::Mixin::ShellOut

      def load_current_resource
        @current_resource ||= Chef::Resource::Swap.new(@new_resource.name)
        @current_resource.path(@new_resource.path)
        @current_resource.size(@new_resource.size)
        @current_resource
      end

      def action_create
        create_swapfile unless swap_exists?(new_resource)
        set_permissions
        mkswap
        swapon
      end

      def action_remove
        swapoff
        remove_swapfile
      end

      def create_swapfile
        command = "dd if=/dev/zero of=#{new_resource.path} bs=1048576 count=#{new_resource.size}"
        shell_out!(command)
      end

      def set_permissions
        shell_out!("chmod 600 #{new_resource.path}")
      end

      def mkswap
        shell_out!("mkswap -f #{new_resource.path}")
      end

      def swapon
        shell_out!("swapon #{new_resource.path}")
      end

      def swapoff
        shell_out!("swapoff #{new_resource.path}")
      end

      def remove_swapfile
        shell_out!("rm #{new_resource.path}")
      end

    end
  end
end