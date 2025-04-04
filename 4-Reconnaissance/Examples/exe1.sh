#!/bin/bash
# Generate IP addresses from a given range.
for ip in {1..254}; do
echo "172.16.10.${ip}" >> 172-16-10-hosts.txt
done
