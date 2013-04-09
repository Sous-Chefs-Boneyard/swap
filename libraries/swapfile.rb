module Swapfile
  module Helpers

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

    protected

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

self.class.send(:include, Swapfile::Helpers)