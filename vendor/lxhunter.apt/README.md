Description
===========

[![Build Status](https://travis-ci.org/lxhunter/apt.png?branch=master)](https://travis-ci.org/lxhunter/apt)

`apt` is an ansible role which was built to help you with:

 * updating the apt-cache
 * control if you want `recommended` packages
 * control if you want `suggested` packages
 * optionally install additional packages
 * optionally configure unattended upgrades

I use the role as part of my common setup.

I hope it helps!

Testing
===========

For your convience I also added vagrant to some testing, please find attached a vagrant file for ubuntu1310-i386


```lang
$ ansible-galaxy install lxhunter.apt
$ cd /usr/local/etc/ansible/roles/lxhunter.apt
$ vagrant up
```

If you need more base images have look at the wonderful project:
* [basebox-packer](https://github.com/misheska/basebox-packer)

Requirements
===========

This role requires Ansible 1.4 or higher.

Tested and supported:
* Ubuntu saucy

Optional Variables
===========

These are the turning knobs and their default values, if you like to change em, just go ahead.

```lang
# group_vars/all.yml

# Sets the amount of time the cache is valid (5m)
apt_cache_valid_time: 3600
# apt by default does not specify whether or not “recommended” packages should be installed.
apt_install_recommends: false
# apt by default does not specify whether or not “suggested” packages should be installed.
apt_install_suggests: false

# Optional: Array of additional packages
apt_install_packages: []

# Optional: attributes for unattended upgrades config
apt_unattended_upgrades_config:
  - { key: 'APT::Periodic::Update-Package-Lists', value: '1' }
  - { key: 'APT::Periodic::Download-Upgradeable-Packages', value: '1' }
  - { key: 'APT::Periodic::AutocleanInterval', value: '7' }
  - { key: 'APT::Periodic::Unattended-Upgrade', value: '1' }
```

Examples
===========

Like so you can include the role in your setup:

```lang
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
