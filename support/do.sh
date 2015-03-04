#!/bin/bash
useradd --create-home --shell /bin/bash --user-group deployer
cp -r /root/.ssh /home/deployer
chown -R deployer:deployer /home/deployer/.ssh 
echo 'deployer ALL=(ALL:ALL) ALL' >> /etc/sudoers
