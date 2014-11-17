#!/usr/bin/env bash

sudo su
cd ~
mkdir .ssh
cp /home/vagrant/.ssh/authorized_keys .ssh/
chmod 600 .ssh
