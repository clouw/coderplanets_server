#!/bin/bash

cd /root/api_server/
MIX_ENV=dev mix phx.server &

# node index &

while true
do
    sleep 100
done
