# [Mosh (Mobile shell) Role for Ansible](https://github.com/jnv/ansible-role-mosh)

Installs [Mosh](http://mosh.mit.edu/) native package on Debian (wheezy), Ubuntu (precise and newer), OpenSuSE (12.3+), and Fedora (16+).

Optional installation from backports repository on Ubuntu and Debian is also supported.

## Usage

Install via [Galaxy](https://galaxy.ansibleworks.com/):

```
ansible-galaxy install jnv.mosh
```

In your playbook:

```yaml
- hosts: all
  roles:
    # ...
    - jnv.mosh
```

And then connect the same way as with SSH, but replace `ssh` with `mosh`:

```
mosh user@host
```

### Install Mosh 1.2 from Backports (Debian, Ubuntu)

Ubuntu Precise (12.04) provides 1.1 version of Mosh, but the newer version is available from backports repository. To install:

1. Enable backports repository; you can use [debian-backports role](https://galaxy.ansibleworks.com/list#/roles/224):

  ```
  ansible-galaxy install jnv.debian-backports
  ```

2. Enable `mosh_debian_use_backports` variable.

For example:

```yaml
- hosts: all
  roles:
  - jnv.debian-backports
  - { role: jnv.mosh, mosh_debian_use_backports: yes}
```

## Variables

- `mosh_pkg` (default: `mosh`): Mosh package name, usually just on most distributions
- `mosh_debian_use_backports` (default: `no`): Whether the backports version should be installed; see [above](#install-mosh-12-from-backports-debian-ubuntu).
- `mosh_debian_backports_target` (default: `{{ansible_distribution_release}}-backports`): Value of the `default_release` to use with [apt module](http://docs.ansible.com/apt_module.html) when `mosh_debian_use_backports` is enabled.
    + The default resolves to, for example, `precise-backports`
