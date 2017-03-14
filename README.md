[![Build Status](https://travis-ci.org/smashingboxes/taperole.svg?branch=master)](https://travis-ci.org/smashingboxes/taperole)
[![Stories in Ready](https://badge.waffle.io/smashingboxes/taperole.png?label=ready&title=Ready)](https://waffle.io/smashingboxes/tape)
# Infrastructure Management

## Deploying & provisioning with tape
**Use Unbuntu trusty64 (16 x64)**

**Enable ssh access via root user**

For a tutorial on getting started: [Taperole: the Smashing Boxes Way to Deploy Your Rails App](http://smashingboxes.com/blog/taperole-the-smashing-boxes-way-to-deploy-your-rails-app)

### Basics

**Install**

*Deprecation notice*: As of taperole 1.7, support for Ubuntu 14.x has been deprecated. If your server does not use Ubuntu 16.x, please install taperole 1.6.0 instead.

* `$ gem install taperole` or add `gem 'taperole', '~>1.7'` to your Gemfile
* `$ brew install ansible`
* Create a [Digital Ocean Droplet](https://www.digitalocean.com/) (or any Ubuntu 16.04 system with ssh access)
* Run `tape installer install` in project repo
* Update your hosts file with the IP address of your server (this can be found in your Droplet). If you go down to "Multistage", you'll see an excellent example of what your hosts file should look like.
* Fill in missing values in `tape_vars.yml`. Should look something like this:

```yaml
app_name: [app name]
be_app_repo: [git repo]
```

* Copy all developers' public keys into the `taperole/dev_keys` directory.
* Use `$ tape ansible provision` for your first deploy, then `$ tape ansible deploy` for subsequent changes.

**Upgrade**

**NOTE**: Upgrading tape on a machine is only supported for patch versions (ie 1.3.0 to 1.3.1). For minor or major versions, it is advised that you stand up a new box, and start from stratch.

```bash
bundle update taperole
tape installer install
```

### Configuration

All default configurations found in `vars/defaults.yml` can be overridden in your local `taperole/tape_vars.yml` file

**Default Node Version**: 4.2.x
**Default Ruby Version** 2.3.0

### Backups
Backups are handled via [duply](http://duply.net/) and are configured via the [Stouts.backup](https://github.com/Stouts/Stouts.backup) ansible galaxy role. Bacups occur every night at 4am under the root user. You can configure your backup schedule and target where you want your backups stored at within your `taperole/tape_vars.yml` file.

The default location for backups is the `/var/lib/postgresql/backups` directory.

All servers in your [production] group will have backups enabled by default.

Detailed configurations can be made in your tape_vars.yml file.

```
# Store Backups on S3
backup_dir: s3+http://[aws_access_key:aws_secret_access_key]@bucket_name[/folder]

# Store Backups on Seperate server via rsync
backup_dir: s3+http://[aws_access_key:aws_secret_access_key]@bucket_name[/folder]

# Adjust Cron Job Schedule (default is every night at 4am)
backup_schedule: "* */4 * * *"

# Change Which Servers are backed up
backup_hosts:
  - production
  - staging
  - qa
```

### Custom roles
You can add app specific ansible roles to `<app_root>/roles`.

You must then specify the roles you want to use in `omnibox.yml` or `deploy.yml`

[Read the Ansible docs on playbook roles here](http://docs.ansible.com/playbooks_roles.html)

### Multistage (environments)
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

Then use the `-l` option to specify the stage/environment

```sh
tape ansible deploy -l staging
```

## Testing
### With vagrant

1. `echo 'y' | tape installer install`
1. `vagrant up`
2. Put the following into your [hosts inventory file](http://docs.ansible.com/intro_inventory.html):

```
[vagrant]
localhost:2222 ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key
```

The port number might be different if other vagrant machines are running, run `vagrant ssh-config`  to find the correct configuration.
You can specify a port using the `ansible_ssh_port` in your hosts inventory file.

3. Update `tape_vars.yml` with information to a rails app you want to deploy
4. `tape ansible provision -l vagrant`

### With Docker
1. Setup your machine to work with Docker. We recommend [Docker Machine](https://docs.docker.com/machine/)

**Test Rails**

2. `docker build -f test/rails/Dockerfile -t tapetest .`
3. `docker run -i -t $(docker images -q tapetest) /start_rails.sh | grep "Hello"`

If the last command resulted in a `<h1>Hello</h1>` then your Rails application deployed successfully!

## Development

```sh
git clone git@github.com:smashingboxes/taperole.git
cd taperole
ansible-galaxy install -r requirements.yml --force
```

## Rails Application Requirements

Your rails application must:
* use posgres as the database
* use puma as the app server
* have access to the taperole gem

Usually, your Gemfile will include something like:
```
# Use postgresql as the database
gem 'pg'

# Use Puma as the app server
gem 'puma'

# Use taperole for deployment
gem 'taperole', '~>1.7'

```

Note: You can also `$ gem install taperole` and not put Taperole in your
Gemfile.

During your first deploy, your app will not have a `secrets.yml` file configured, and Tape will prompt you to provide one:

```
TASK: [backend_config | Ask for secrets.yml] **********************************
ok: [159.203.126.223] => {
    "msg": "You've got to upload secrets.yml to /home/deployer/kevinrkiley/config to continue"
}
```

To continue the deploy, SSH into the server as the `deployer` user and create your `config/secrets.yml` file in the app directory. The deploy will automatically continue when the file is saved.

### Rake tasks

To run ad-hoc rake tasks, you can use the following:

```
tape ansible rake --task users:rank
```

## Slack integration

Tape includes built-in support for posting messages to slack at the beginning and end of deployments.

Here are the steps needed to enable this functionality:

1. Start by setting up [an incoming webhook integration](https://my.slack.com/services/new/incoming-webhook/)
2. Add that URL to `tape_vars.yml` as `slack_webhook_url`
3. Profit.
