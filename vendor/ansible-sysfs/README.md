## sysfs

[![Build Status](https://travis-ci.org/Oefenweb/ansible-sysfs.svg?branch=master)](https://travis-ci.org/Oefenweb/ansible-sysfs) [![Ansible Galaxy](http://img.shields.io/badge/ansible--galaxy-sysfs-blue.svg)](https://galaxy.ansible.com/Oefenweb/sysfs)

Manages sysfs in Debian-like systems (using [sysfsutils](http://packages.ubuntu.com/trusty/sysfsutils)).

#### Requirements

* `sysfsutils` (will be installed)

#### Variables

* `sysfs_sysfs_d_files` [default: `{}`]: `/etc/sysfs.d/*` file(s) declarations
* `sysfs_sysfs_d_files.key`: The name of the sysfs configuration file (e.g `001-transparent-hugepage.conf`)
* `sysfs_sysfs_d_files.key.{n}.action` [optional]: `mode` or `owner`, when not specified the new value for specified attribute is set 
* `sysfs_sysfs_d_files.key.{n}.attribute` [required]: Name of an attribute, specified as a path without `/sys` prefix (e.g. `kernel/mm/transparent_hugepage/enabled`)
* `sysfs_sysfs_d_files.key.{n}.value` [required]: Value for the attribute (e.g. `never`)

#### Dependencies

None

#### Example

##### Simple

```yaml
---
- hosts: all
  roles:
    - sysfs
```

##### Advanced

```yaml
---
- hosts: all
  roles:
    - sysfs
  vars:
    sysfs_sysfs_d_files:
      000-power-state.conf:
        - action: mode
          attribute: power/state
          value: '0660'
        - action: owner
          attribute: power/state
          value: 'root:vagrant'
      001-transparent-hugepage.conf:
        - attribute: kernel/mm/transparent_hugepage/enabled
          value: never
        - attribute: kernel/mm/transparent_hugepage/defrag
          value: never

```

#### License

Apache

#### Author Information

* Mischa ter Smitten (based on work of [Lukasz Szczesny](https://github.com/wybczu))

#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Oefenweb/ansible-sysfs/issues)!
