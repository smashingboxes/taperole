### 1.3
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
