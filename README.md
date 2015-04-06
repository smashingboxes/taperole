[![Stories in Ready](https://badge.waffle.io/smashingboxes/taperole.png?label=ready&title=Ready)](https://waffle.io/smashingboxes/tape)
# Infrastructure Management

## Deploying & provisioning with tape
**Use Unbuntu precise64 (12.04 x64)** 

**Enable ssh access via root user**

### Basics

**Install**

* `gem install taperole` or `gem 'taperole'`
* run `tape installer install` in project repo
* Updated the hosts file with the IP address of your server
* Fill in missing values in `tape_vars.yml`
* Copy all developers public keys into some dir and specify that dir inside `tape_vars.yml` (dev_key_files)
* `tape ansible everything`

**Upgrade**

```
bundle upgrade tape
tape installer install
```

### Custom roles
You can write app specific roles in the roles files storred in the `roles` directory

You must then specify the roles you want to use in `omnibox.yml` or `deploy.yml`

[Read the Ansible docs on playbook roles here](http://docs.ansible.com/playbooks_roles.html)

### Multistage
You can setup multistage by defining your hosts file as follows

```
[production]
0.0.0.0 be_app_env=production be_app_branch=SOME_BRANCH
[staging]
0.0.0.0 be_app_env=staging be_app_branch=SOME_BRANCH
[omnibox:children]
production
staging
```

then use the `-l` option to specify the staging

```sh
tape ansible deploy -l staging
```

## Testing
### With vagrant


1. `vagrant up` or `tape vagrant create`
2. Put the following into your [hosts inventory file](http://docs.ansible.com/intro_inventory.html):

```
[vagrant]
<192.168.13.37> ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key
```

The port number might be different if other vagrant machines are running, run `vagrant ssh-config`  to find the correct configuration.
You can speicfy a port using the `ansible_ssh_port` in your hosts inventory file.

3. Update `tape_vars.yml` with information to a [rails app you want to deploy](https://github.com/BrandonMathis/vanilla-rails-app)
4. `tape ansible everything -l vagrant`


### With QEMU

1. `tape qemu create --name fe_test`
2. `tape qemu start --name fe_test -p2255`
3. `ssh-add ./id_rsa_sb_basebox`
4. `echo 'localhost:2255' >test_hosts`
5. `tape ansible everything`

Run `tape -h` for a quick rundown of the tool's modules and options.

## Development

```sh
git clone git@github.com:smashingboxes/tape.git
cd tape
ansible-galaxy install -r requirements.yml --force
```
