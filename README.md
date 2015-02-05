[![Stories in Ready](https://badge.waffle.io/smashingboxes/tape.png?label=ready&title=Ready)](https://waffle.io/smashingboxes/tape)
# Infrastructure Management

[Trello](https://trello.com/b/4sOCutfn/smashingboxer)


## Deploying & provisioning with tape
It is advised that, if you are provisioned your box with an older version of ansible, you stand up a clean box.

* **Use Unbuntu precise64 (12.04 x64)**

### Basics

* Add the following to your gemfile.

```ruby
gem 'tape', github: 'smashingboxes/tape', group: :development
```

* `bundle install`
* `tape installer install`
* Updated the hosts file with the IP address of your server

```
[omnibox]
0.0.0.0
```

* Fill in missing values in `tape_vars.yml`
* Copy all developers public keys into some dir and specify that dir inside `tape_vars.yml` (dev_key_files)
* `tape ansible everything`

### Custom roles
You can write app specific roles in the roles files storred in the `roles` directory

**App-Specific Provisioning Roles**

* `before_database`
* `before_general`
* `before_web`
* `before_ruby`
* `before_app_server`

**App-Specific Deploy Roles**

* `before_deploy`
* `after_deploy`

### Multistage
You can setup multistage by defining your hosts file as follows

```
[production]
0.0.0.0
[staging]
0.0.0.0
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
2. Put the following into your hosts file:

```
[vagrant]
localhost:2222 ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key
```

The port number might be different if other vagrant machines are running, run `vagrant ssh-config`  to find the correct configuration.

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
