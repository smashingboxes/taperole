[![Stories in Ready](https://badge.waffle.io/smashingboxes/taperole.png?label=ready&title=Ready)](https://waffle.io/smashingboxes/tape)
# Infrastructure Management

[![Join the chat at https://gitter.im/smashingboxes/taperole](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/smashingboxes/taperole?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Deploying & provisioning with tape
**Use Unbuntu precise64 (14.04 x64)**

**Enable ssh access via root user**

### Basics

**Install**

* `$ gem install taperole` or add `gem 'taperole', '~>1.3'` to your Gemfile
* `$ brew install ansible`
* Create a [Digital Ocean Droplet](https://www.digitalocean.com/) (or any Ubuntu 14.04 system with ssh access)
* Run `tape installer install` in project repo
* Update your hosts file with the IP address of your server (this can be found in your Droplet). If you go down to "Multistage", you'll see an excellent example of what your hosts file should look like.
* Fill in missing values in `tape_vars.yml`. Should look something like this:
```
app_name: [app name]

be_app_repo: [git repo]
```
* Copy all developers public keys into a new directory (dev_keys is a good example for the name of that directory).
* `$ tape ansible everything`

**Upgrade**

**NOTE: Upgrading tape on a machine is only supported for patch versions (ie 1.3.0 to 1.3.1). For minor or major versions, it is advised that you stand up a new box, and start from stratch.

```
bundle update taperole
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

## 1.3 Documentation

### Local System Requirements

We're assuming that you're starting with the following things installed and working on your local machine:
* unix based operating system
* ruby (version 1.9.3 or greater)
 Run `$ ruby --version`. You should see something like `ruby 2.2.3p173` in the output. If you see nothing or get an error, you need to install ruby. If you see something less than 1.9.3, you need to upgrade.
* an ssh key
 You'll need an ssh key to set up access to your server. GitHub has a [great tutorial](https://help.github.com/articles/generating-ssh-keys/) on this.
* git and GitHub (or another remote host for your code)
 Here's a good article on how to get going with git: https://help.github.com/articles/set-up-git/.
* ansible
 On a mac, we suggesting using Homebrew to install ansible. Otherwise, please refer to the ansible documentation: http://docs.ansible.com/ansible/intro_installation.html.

### Rails Application Requirements

Your rails application must:
* use posgres as the database
* use unicorn as the app server
* have access to the taperole gem
Usually, your gemfile will include something like:
```
# Use postgresql as the database
gem 'pg'

# Use taperole for deployment
gem 'taperole'

# Use Unicorn as the app server
gem 'unicorn'
```
Note: You can also `$ gem install taperole` and not put Taperole in your Gemfile.

### Your Host Server

Below are instructions for creating a digital ocean droplet to host your application.
This is not required, as long as you have root access via ssh to an Unbuntu precise64 (14.04 x64) server.

1. Click "Create Droplet"
2. Name your droplet. (For the purposes of this example, we'll be calling our droplet 'walkthrough'.)
3. Select a size for your droplet. The smallest size is fine for our purposes, but if you're deploying a larger app, select whatever size is appropriate.
4. Select a datacenter region.
5. Choose Ubuntu 14.04.3 x64 as your image.
6. Add your ssh key to the droplet.
7. Create the droplet!

To ensure you have ssh access as root to your server:
`$ ssh root@0.0.0.0` should get you into the server.
`$ pwd` in the server and you should see `/root`.
`$ exit` to get close your session.

### Deploying with Taperole

1. Confirm that `taperole`, `pg`, and `unicorn` are in your gemfile.
2. `$ bundle`
3. When asked `Are you going to use vagrant? (y/n):`, say `n`.
4. Make your hosts file. Assuming you're going to have multiple environments, it should look something like this:
```
[production]
0.0.0.0 be_app_env=production be_app_branch=master

[omnibox:children]
production
```
5. Give yourself access to the server. This needs to be the same ssh key that you used on your digital ocean droplet. So create a file called your_name.pub in the dev_keys folder that was generated by tape installer install. `pbcopy < ~/.ssh/id_rsa.pub` in your terminal again, then paste the resule into the file you just created.
6. Update your tape_vars.yml file.
```
app_name: walkthrough

be_app_repo: [git repo]

dev_key_files:
  - dev_keys/your_name.pub
```
7. Add this to your gitignore.
```
# Ignore this stuff for Taperole
config/secrets.yml
config/database.yml
```
8. If it isn't automatically, comment out front end stuff:
 * `# fe_deploy` in omnibox.yml
 * `# - frontend_deploy` in deploy.yml

9. git add and commit and push to master
10. Run `$ tape ansible everything.` This will take a long time, so grab a sandwich or something.
11. This should chug right along until it gets to
```
TASK: [backend_config | Ask for secrets.yml] **********************************
ok: [159.203.126.223] => {
    "msg": "You've got to upload secrets.yml to /home/deployer/kevinrkiley/config to continue"
}
```
where it will hang. Don't cancel the deploy.
12. Open a new terminal tab and generate a secret key by running `$ rake secret` from the root directory of your rails app. Don't lose this.
13. Run `$ ssh deployer@0.0.0.0`
14. Once you're in the server, `$ cd walkthrough/config`. If you `$ ls`, you should see that there is no `secrets.yml` file. `$ vi secrets.yml` to create it.
15. When you're done secrets.yml should look something like:
```
production:
  secret_key_base: thisisthesecretkeyyougeneratedinstep9
```
16. Your deployment should automatically continue.

