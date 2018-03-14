#
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

property :path,    String, name_property: true
property :size,    Integer
property :persist, [true, false], default: false
property :timeout, Integer, default: 600
property :swappiness, Integer

action :create do
  do_create(swap_creation_command) unless swap_enabled?

  if new_resource.swappiness
    sysctl_param 'vm.swappiness' do
      value new_resource.swappiness
    end
  end
end

action :remove do
  swapoff if swap_enabled?
  remove_swapfile if ::File.exist?(new_resource.path)
end

action_class do
  include SwapCookbook::Helpers
end
