module Swapfile
  module Helpers

    # The block size (1MB)
    def block_size
      1048576
    end

    def swap_exists?(nr)
      ::File.exists?(nr.path) && ::File.size?(nr.path).to_i/block_size == nr.size
    end

    def swap_creation_command(nr)
      size = block_size * nr.size
      if compatible_filesystem?(nr) && compatible_kernel(nr)
        command = "fallocate -l #{size} #{nr.path}"
      else
        command = "dd if=/dev/zero of=#{nr.path} bs=#{block_size} count=#{nr.size}"
      end
      Chef::Log.debug("#{nr} swap creation command is '#{command}'")
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