# Site to site Wireguard VPN gateway setup carried out with docker containers.

*Accessing a subnet that is behind a WireGuard client container using a site-to-site setup*

wireguard container git repo: https://github.com/linuxserver/docker-wireguard

#### Problem Summary

We want to have access to the local subnet of one of the docker container hosts through the VPN tunnel.

#### Solution Summary

We'll create a site-to-site connection with **WireGuard** allowing us to access the local subnet under the wireguard containerby connecting through a cloud server in the middle. (any other machine with a real IP would also work)

## Working Example

Before we start, you should know how wireguard is used in docker, for that I recommend reading the provided information on the official repository README. The URL can be found above.  
***
*Note 1. THE REPOSITORY CONTAINS CONFIGURATION FILES THAT ARE ALREADY IN USE, YOU SHOULD START ON A CLEAN SLATE BY BRINGING UP THE CONTAINERS AND THEN REPLACING THE NEEDED LINES IN THE wg0.conf FILES*

*Note 2. There are some further implementations done to better fit the initial goal of this project, consisting of grabbing Host's A LAN network address and inserting it in the container for automatic routing. This can be avoided by not using the script to start the container found in the respective directory of 30_wireguard-router.*

*Note 3. The initial configuration files for the peers are created in vpn-site2site-gw/10_wireguard-server/vpn-server-conf/ under the names of peer1, peer2, peern.. It is recommended to get those configuration files and place them under the vpn-router-conf/ and vpn-client-conf/ with the name of wg0.conf. After that the configuration files need to be modified according to the bellow article.*
***

Now that we have cleared some future misunderstandings let's define our three hosts.  They all have **WireGuard** docker containers installed.

```A```  the Linux machine on the *local subnet*, **behind the NAT/firewall**, that also has a wireguard docker container in client mode running that is going to be used as a router between the docker bridge and the docker host's LAN. 

```B```  the Linux cloud server (*VPS, like an Amazon EC2 instance*), that is going to serve as the VPN Server that we connect to with other clients, who might want to have access to the LAN of host A.

```C```  a third **WireGuard** client; test client to check if connection is working
***

#### Host 'A' (ROUTER)

Host A's configuration file:

```
# Router config
[Interface]
Address = 10.13.13.3
PrivateKey = <HOST 'B' PRIVATE KEY>
ListenPort = 51820                           #Auto assigned when using docker containers for wireguard
DNS = 10.13.13.1                             #Optional

# IP tables
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip route add 192.168.1.0/24 via 172.21.0.1
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip route del 192.168.1.0/24 via 172.21.0.1

# IP forwarding
PreUp = sysctl -w net.ipv4.ip_forward=1

# Server config
[Peer]
PublicKey = <HOST 'B' PUBLIC KEY>
PresharedKey = <HOST 'B' PRE-SHARED KEY>
Endpoint = <HOST 'B' IP ADDRESS>:51820       #this address should be a real IP, not private
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25                     #to keep connections alive across NAT
```

#### Host 'B' (VPN SERVER)

Host B's configuration file:

```[Interface]
Address = 10.13.13.1
ListenPort = 51820
PrivateKey = <HOST 'B' PRIVATE KEY>

# IP tables
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE

[Peer]
# client (host C)
PublicKey = <HOST 'C' PUBLIC KEY>
PresharedKey = <HOST 'C' PRE-SHARED KEY>
AllowedIPs = 10.13.13.2/32

[Peer]
# router (host A)
PublicKey = <HOST 'A' PUBLIC KEY>
PresharedKey = <HOST 'A' PRE-SHARED KEY>
AllowedIPs = 10.13.13.3/32, 172.21.0.0/24, 192.168.1.0/24 #Those ranges are important, they signify allowed addresses over the tunnel
PersistentKeepalive = 25
```
#### Host C (CLIENT)

Host C's configuration file:

```
[Interface]
Address = 10.13.13.3
PrivateKey = <HOST 'C' PRIVATE KEY>
ListenPort = 51820
DNS = 10.13.13.1

[Peer]
PublicKey = <HOST 'B' PUBLIC KEY>
PresharedKey = <HOST 'B' PRE-SHARED KEY>
Endpoint = <HOST 'B' IP ADDRESS>:51820
AllowedIPs = 0.0.0.0/0
```

**You're finished.**  
Make sure the **WireGuard** container is running on both HOSTS A and B, and then on the  HOST C, after connecting to HOST B with **WireGuard** you should be able to access the LAN/subnet of host A.


