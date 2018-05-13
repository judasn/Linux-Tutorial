#!/bin/sh

time1=$(date "+%Y-%m-%d %H:%M:%S")

echo "${time1}" >> /opt/1.txt

sleep 5s

time2=$(date "+%Y-%m-%d %H:%M:%S")

echo "${time2}" >> /opt/1.txt
