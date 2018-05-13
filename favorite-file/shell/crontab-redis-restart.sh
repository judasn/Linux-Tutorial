#!/bin/sh

redis-cli -h 127.0.0.1 -p 6379 -a 123456789 shutdown

sleep 5s

/usr/local/bin/redis-server /etc/redis.conf


