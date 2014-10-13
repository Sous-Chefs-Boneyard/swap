swap Cookbook CHANGELOG
=======================
This file is used to list changes made in each version of the swap cookbook.

v0.3.8
------
- Missing missing method name get_fallocate_command

v0.3.7
------
- Updated to latest test harness

v0.3.6
------
- Remove `size` as a required attribute, since it doesn't make sense to require it during the "remove" action


v0.3.1
------
- **CHANGELOG is deprecated - see [releases](https://github.com/sethvargo-cookbooks/swap/releases)**

v0.3.0
------
- Integrate test-kitchen
- Integrate foodcritic
- Integrate chefspec
- Integrate strainer
- Integrate knife testing
- Add travis support
- Add `persist` key to write to `fstab`

v0.2.0
------
- Use fallocate if available - @andrewgross
- Small code restructure

v0.1.1
------
- Fix error in documentation (it's MB, not GB) (@dougal)

v0.1.0
------
- Initial release
