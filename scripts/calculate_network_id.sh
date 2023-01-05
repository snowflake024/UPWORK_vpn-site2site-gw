#!/bin/bash

# Fetch default NIC address
DEFAULT_NIC=$(ip route list | awk '/^default/ {print $5}')


# Calculate network parameters
IP_ARRAY=()

ip -o -f inet addr show $DEFAULT_NIC | awk '{print $4}' | ./net_calc.sh >> list-tmp

readarray -t IP_ARRAY < ./list-tmp


# Garbage collection
rm list-tmp -f


# Fix CIDR prefix
IPprefix_by_netmask () {
   c=0 x=0$( printf '%o' ${1//./ } )
   while [ $x -gt 0 ]; do
       let c+=$((x%2)) 'x>>=1'
   done
   echo /$c ; }


# Arraning letters and numbers
NETWORK=$(echo "${IP_ARRAY[2]}" | cut -c 9- | xargs)
NETMASK=$(echo "${IP_ARRAY[1]}" | cut -c 9- | xargs)
CIDR_MASK=$(IPprefix_by_netmask $NETMASK)
ID="$NETWORK$CIDR_MASK"

# Final output
echo "$ID"
