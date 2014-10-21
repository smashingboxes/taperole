# WeaveUp Infrastructure Management

We've got the Ansible!

## Why?

Our old Capistrano system is too much of a ballache to add new tasks to.  Ansible is being used here for infrastructure mgmt since Capistrano isn't even the right tool for the job.

## Running

To generate hosts from capistrano hosts (only ip addresses supported): `./mkhosts.sh`

1) `ansible-galaxy install -r Rolefile` to install deps
2) `ssh-add` root keys from Passpack
3) `ansible-playbook -ihosts omnibox.yml`

## Testing

1) get vagrant base box SSH key from Vagrant's GH repo and `ssh-add` it
2) install vbox
3) `vagrant up`
4) ssh to vagrant box (host-only ip in Vagrantfile, or `vagrant ssh`)
5) `sudo mkdir /root/.ssh/ && cp .ssh/authorized_keys /root/.ssh/authorized_keys && chmod /root/.ssh/authorized_keys 0600`
6) `ansible_playbook -itest_hosts omnibox.yml`

## Playbooks

### omnibox

This is the setup right now.  This just puts everything on all the hosts, turning them all into single-machine deployments

## Roles

### General

General encapsulates basic stuff every box should have like unattended upgrades and swap space.

### Deployer User

This user needs to have some SSH keys so all the devs on the project can ssh to machines and do things.  Deployer user keys will live under roles/deployer\_user/files/keys.

### Web

Basic nginx installation, configured to work with unicorns running on the same box

### app\_server

Runs unicorns executing app code
