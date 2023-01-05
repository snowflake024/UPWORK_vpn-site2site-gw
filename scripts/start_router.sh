!/bin/bash

# Create a docker bridge network for the container
docker network create --subnet 172.21.0.0/24 wgnet


# Fetch subnet address of the docker host
## Initially planned for automatic routing insertion, later decided not to
NETWORK=$(./calculate_network_id.sh)

echo "LAN ID is $NETWORK, check with wg0.conf routing"

# Start docker compose
cd ../30_wireguard-router && docker compose up -d
