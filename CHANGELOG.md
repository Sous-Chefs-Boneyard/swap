# swap Cookbook CHANGELOG

This file is used to list changes made in each version of the swap cookbook.

## v2.2.2 (2018-04-07)

- The swap resource from this cookbook is now shipping as part of Chef 14\. With the inclusion of this resource into Chef itself we are now deprecating this cookbook. It will continue to function for Chef 13 users, but will not be updated.

## v2.2.1 (2018-03-15)

- Fix #60, incorrect permissions on `set_permissions`

## v2.2.0 (2018-03-14)

- General tidy up of resources
- Migrate helpers into the helpers file
- Cleanup test suites

## v2.1.0 (2017-08-17)

- Added sysctl and swappiness to create call. This adds a dependency on systctl
- Require Chef 12.7 or later since 12.5/12.6 had issues with custom resources
- Add integration testing in Travis with kitchen-dokken
- Add testing with Delivery local mode
- Update the dokken config to use the dokken images
- Fix the license metadata to be a SPDX compliant license string
- Convert the integration tests from bats to InSpec
- Add a very basic ChefSpec test

## v2.0.0 (2017-02-23)

- Now supports a timeout property for create
- Converted to a custom resource to resolve the failures in the 1.0 release and wired up proper converge messaging. This requires Chef 12.5 or later

## v1.0.0 (2017-02-22)

- This cookbook has been transferred to the Sous Chefs. See sous-chefs.org
- Require Chef 12.1 or later

## v0.4.0

- Use provides if available to avoid deprecation warnings on Chef 12.4+
- Add -P to df to account for long device names
- Check that swap exist before removing it
- Add a chefignore file to limit the files uploaded to the Chef server
- Add new issues_url, source_url and chef_version metadata
- Update testing with a Rakefile, Cookstyle, and ChefDK testing in Travis
- Update the requirements section in the Readme
- Add supported platforms to the metadata

## v0.3.8

- Missing missing method name get_fallocate_command

## v0.3.7

- Updated to latest test harness

## v0.3.6

- Remove `size` as a required attribute, since it doesn't make sense to require it during the "remove" action

## v0.3.1

- **CHANGELOG is deprecated - see [releases](https://github.com/sethvargo-cookbooks/swap/releases)**

## v0.3.0

- Integrate test-kitchen
- Integrate foodcritic
- Integrate chefspec
- Integrate strainer
- Integrate knife testing
- Add travis support
- Add `persist` key to write to `fstab`

## v0.2.0

- Use fallocate if available - @andrewgross
- Small code restructure

## v0.1.1

- Fix error in documentation (it's MB, not GB) (@dougal)

## v0.1.0

- Initial release
