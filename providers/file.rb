#
# Author:: Seth Vargo <sethvargo@gmail.com>
# Cookbook:: swap
# Provider:: file
#
# Copyright 2012, Seth Vargo
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

# Creates a swap file of the given size and the given path
action :create do
  bash "create swapfile #{new_resource.path}" do
    code          "dd if=/dev/zero of=#{new_resource.path} bs=#{block_size} count=#{new_resource.size}"
    not_if        { swap_exists? }
  end

  file new_resource.path do
    owner         'root'
    group         'root'
    mode          '0600'
    action        :nothing
    subscribes    :create, "bash[create swapfile #{new_resource.path}]"
  end

  bash "swapon #{new_resource.path}" do
    code          "swapon #{new_resource.path}"
    action        :nothing
  end

  bash "mkswap #{new_resource.path}" do
    code          "mkswap -f #{new_resource.path}"
    action        :nothing
    subscribes    :run, "bash[create swapfile #{new_resource.path}]"
    notifies      :run, "bash[swapon #{new_resource.path}]"
  end

  mount '/dev/null' do
    action        :enable
    device        new_resource.path
    fstype        'swap'
  end
end

# Deletes the swap file at the given path
action :remove do
  file new_resource.path do
    action        :nothing
  end

  bash "swapoff #{new_resource.path}" do
    code          "swapoff #{new_resource.path}"
    notifies      :delete, "file[#{new_resource.name}]"
    only_if       { swap_exists? }
  end
end

protected
# The block size (1MB)
def block_size
  1048576
end

def swap_exists?
  ::File.exists?(new_resource.path) && ::File.size?(new_resource.path).to_i/block_size == new_resource.size
end
