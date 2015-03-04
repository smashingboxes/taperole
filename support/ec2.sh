#!/bin/bash
useradd --create-home --shell /bin/bash --user-group deployer
cp -r /home/ubuntu/.ssh /home/deployer
chown -R deployer:deployer /home/deployer/.ssh 
echo 'deployer ALL=(ALL:ALL) ALL' >> /etc/sudoers
