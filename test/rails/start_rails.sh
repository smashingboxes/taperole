#!/usr/bin/env bash
rm -rf /home/deployer/vanilla/pids/puma.pid
rm -rf /home/deployer/vanilla/pids/puma.state
rm -rf /home/deployer/vanilla/tmp/*.sock
service postgresql start
monit start puma
monit start nginx
sleep 2
curl https://localhost --insecure
