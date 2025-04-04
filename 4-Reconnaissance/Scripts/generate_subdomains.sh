#!/bin/bash

DOMAIN="${1}"
FILE="${2}"

# Read the file from standard input and echo the full domain.
while read -r subdomain; do

echo "${subdomain}.${DOMAIN}"

done < "${FILE}"
