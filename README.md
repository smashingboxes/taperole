# Infrastructure Management

[Trello](https://trello.com/b/4sOCutfn/smashingboxer)


## Deploying & provisioning with smashing_boxer
It is advised that, if you are provisioned your box with an older version of ansible, you stand up a clean box.

* **Use Unbuntu precise64 (12.04 x64)**
* Add the following to your gemfile.

```
gem 'smashing_boxer', git: 'git@github.com:smashingboxes/smashing_boxer.git', group: :development
```

* `bundle install`
* `smasing_boxer installer install`
* Updated the hosts file with the IP addess of your server

```
[omnibox]
0.0.0.0
```

* Fill in missing values in `site_vars.yml`
* Copy all developers public keys into some dir and specify that dir inside `site_vars.yml` (dev_key_files)

##Testing
###With vagrant


1. `smashing_boxer vagrant create`
2. Put the following into your hosts file

```
[omnibox]
192.168.13.37 ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key
```
3. Update `site_vars.yml` with information to a [rails app you want to deploy](https://github.com/BrandonMathis/vanilla-rails-app)
4. `smashing_boxer ansible everything -i vagrant`


###With QEMU

1. `smashing_boxer qemu create --name fe_test`
2. `smashing_boxer qemu start --name fe_test -p2255`
3. `ssh-add ./id_rsa_sb_basebox`
4. `echo 'localhost:2255' >test_hosts`
5. `smashing_boxer ansible everything -i test_hosts`
 
Run `smashing_boxer -h` for a quick rundown of the tool's modules and options.
