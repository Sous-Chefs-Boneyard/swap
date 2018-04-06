name 'swap'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license 'Apache-2.0'
description 'Manage swap and swapfiles with Chef'
long_description 'A resource for easily creating a managing swap files ' \
                 'and swap partitions in Chef recipes.'
version '2.2.2'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/swap'
issues_url 'https://github.com/sous-chefs/swap/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)

depends 'sysctl', '>= 1.0'
