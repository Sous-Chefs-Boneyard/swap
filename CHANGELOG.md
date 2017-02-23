# swap Cookbook CHANGELOG

This file is used to list changes made in each version of the swap cookbook.

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
