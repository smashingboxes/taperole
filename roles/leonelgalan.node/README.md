# leonelgalan.node [![Build Status](https://travis-ci.org/leonelgalan/ansible-node.svg)](https://travis-ci.org/leonelgalan/ansible-node)

Installs **latest** nodejs, the **latest** npm, and desired packages. At the time of writing (January 26, 2015):

* Node.js v0.10.36
* npm 2.3.0

# Role Variables

Default variables are:

```yml
---
npm_packages: []
```

## Dependencies

* nodesource.node

```shell
ansible-galaxy install --role-file=requirements.yml --force
```

## Example Playbook
```yml
- hosts: all

roles:
  - role: leonelgalan.node
  npm_packages:
    - name: gulp
    - name: bower
      version: 1.3.12
    - path: ../local/package
```

## Vagrant

```shell
vagrant up
```

## License

_leonelgalan.node_ is released under the [MIT License](http://opensource.org/licenses/MIT  ).

## Author Information

Leonel Galán (<leonel@smashingboxes.com>)
