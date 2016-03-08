Description
===========

`apt` is an ansible role which was built to help you with:

 * updating the apt-cache
 * lets you control the configuration of apt by modifing the content of `/etc/apt/apt.conf.d`
 * optionally install additional packages

I use the role as part of my common setup.

I hope it helps!

Testing
===========

For your convience I also added test-kitchen for testing, please find attached the test kitchen.yml file for:

* Debian Jessie
* Debian Squeeze
* Ubuntu Vivid Vervet
* Ubuntu Trusty Tahr
* Ubuntu Utopic Unicorn

```lang
$ ansible-galaxy install lxhunter.apt
$ cd /usr/local/etc/ansible/roles/lxhunter.apt
$ kitchen test
```

#### Requirements for test kitchen

I used homebrew with rbenv for ruby on osx.

required:
```shell
$ gem install test-kitchen kitchen-docker kitchen-ansible kitchen-vagrant
```

Requirements
===========

This role requires Ansible 1.4 or higher.

Tested and supported:
* Debian Jessie
* Debian Squeeze
* Ubuntu Vivid Vervet
* Ubuntu Trusty Tahr
* Ubuntu Utopic Unicorn

Optional Variables
===========

These are the turning knobs and their default values, if you like to change em, just go ahead.

```yaml
# Default: Sets the amount of time the cache is valid (5m)
apt_cache_valid_time: 3600

# apt by default does not specify whether or not “recommended” packages should be installed.
# apt by default does not specify whether or not “suggested” packages should be installed.
apt_config:
  - { key: 'APT::Install-Recommends', value: 'false', file: '10general' }
  - { key: 'APT::Install-Suggests', value: 'false', file: '10general' }

# Optional: Array of additional packages
apt_install_packages: ['sudo']

# Optional: Array of packages to be purged
apt_purge_packages: ['rpcbind']

```

Examples
===========

Like so you can include the role in your setup:

```shell
# playbook.yml

- { role: lxhunter.apt }
```

Quote
==========
"I want to know God's thoughts; the rest are details."
- Albert Einstein

Contribute
==========

[Tutorial](http://kbroman.github.io/github_tutorial/pages/fork.html)

License and Author
==================

Author:: [Alexander Jäger](https://github.com/lxhunter)

Copyright 2014

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
