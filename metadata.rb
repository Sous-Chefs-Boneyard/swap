name             'swap'
maintainer       'Nordstrom Inc. Fork from Sous Chefs'
maintainer_email 'itpcmall@nordstrom.com'
license          'Apache-2.0'
description      'Manage swap and swapfiles with Chef'
long_description 'A resource for easily creating a managing swap files ' \
                 'and swap partitions in Chef recipes.'
version          '2.3.0'

%w[ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux].each do |os|
  supports os
end

source_url       'https://git.nordstrom.net/projects/ITS/repos/swap/browse'
issues_url       'https://jira.nordstrom.net/browse/PCM'
chef_version     '>= 12.7' if respond_to?(:chef_version)

depends          'sysctl', '>= 1.0'
