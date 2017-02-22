name 'swap'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license 'Apache 2.0'
description 'Manage swap and swapfiles with Chef'
long_description 'Provides an LWRP for easily creating a managing swap files ' \
                 'and swap partitions in Chef recipes.'
version '0.4.0'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end

source_url 'https://github.com/sethvargo-cookbooks/swap' if respond_to?(:source_url)
issues_url 'https://github.com/sethvargo-cookbooks/swap/issues' if respond_to?(:issues_url)
chef_version '>= 11' if respond_to?(:chef_version)
