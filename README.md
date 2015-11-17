[![Stories in Ready](https://badge.waffle.io/smashingboxes/taperole.png?label=ready&title=Ready)](https://waffle.io/smashingboxes/tape)
# Infrastructure Management

[![Join the chat at https://gitter.im/smashingboxes/taperole](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/smashingboxes/taperole?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Deploying & provisioning with tape
**Use Unbuntu precise64 (12.04 x64)** 

**Enable ssh access via root user**

### Basics

**Install**

* `$ gem install taperole` or `gem 'taperole'`
* `$ brew install ansible`
* Create a [Digital Ocean Droplet](https://www.digitalocean.com/)
* Run `tape installer install` in project repo
* Update your hosts file with the IP address of your server (this can be found in your Droplet). If you go down to "Multistage", you'll see an excellent example of what your hosts file should look like.
* Fill in missing values in `tape_vars.yml`. Should look something like this:
```
app_name: [app name]

be_app_repo: [git repo]

dev_key_files:
  - dev_keys/name1.pub
  - dev_keys/name2.pub
```
* Copy all developers public keys into a new directory (dev_keys is a good example for the name of that directory). Then specify that dir inside `tape_vars.yml` (dev_key_files)
* `$ tape ansible everything`

**Upgrade**

```
bundle upgrade tape
tape installer install
```

### Custom roles
You can write app specific roles in the roles files stored in the `roles` directory

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

Then use the `-l` option to specify the staging

```sh
tape ansible deploy -l staging
```

## Testing
### With vagrant


1. `vagrant up`
2. Put the following into your [hosts inventory file](http://docs.ansible.com/intro_inventory.html):

```
[vagrant]
localhost:2222 ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key
```

The port number might be different if other vagrant machines are running, run `vagrant ssh-config`  to find the correct configuration.
You can specify a port using the `ansible_ssh_port` in your hosts inventory file.

3. Update `tape_vars.yml` with information to a [rails app you want to deploy](https://github.com/BrandonMathis/vanilla-rails-app)
4. `tape ansible everything -l vagrant`

## Development

```sh
git clone git@github.com:smashingboxes/tape.git
cd tape
ansible-galaxy install -r requirements.yml --force
```
