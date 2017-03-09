#!/usr/bin/env bash
rm -rf /tmp/*.sock
service postgresql start
service monit start
monit start all
sleep 10
curl https://localhost --insecure
