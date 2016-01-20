### 1.4.0
* Install nvm which installed node
* Update postgres role
* Update rbenv role
* New memcached role that supports ansible 2.0
* Update unattended-upgrades role

### 1.3.6
* Added support for ansible 2.0

### 1.3.5
* Fix issue with missing opts for slack notifier failing ansible commands
### 1.3.3
* Added slack notifications
* Added fe build command to tape_vars.yml template
* Fixed issues where test for bower.json was returning 1 exit code

### 1.3.2
* Fixes ssh_args to actually enable agent forwarding for everyone

### 1.3.0
* Puts all tape focused files for a repo into a taperole/ directory
* Installs mosh
* Installs htop
* Removes vagrant runner
* Auto-detect dev_keys
* Only try to fe_deploy if fe_app_repo is defined
* Control nginx with monit
* Updates Readme
* Disable retry files
* tape will not check that requires vars are defined before proceeding with provisioning

### 1.2.3
* Fixed issue where users who were using vagrant could not ssh into the deployer user
* Fixed issue where vagrant boxes init script was failing because .ssh dir already existed 
