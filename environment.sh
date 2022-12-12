# source specified file before startup.
ENVFILE=

# set route for tunnel into the default routing table outside of the scope of strongswan
# use this just in conjunction with calico and host networking
SET_ROUTE_DEFAULT_TABLE=FALSE

# local IP of the node the container is supposed to be running on
# this IP has to able to be bound by the service and could also be '%any'
IPSEC_LOCALIP=

# The local identifier to be used during the handshake.
# This can either be an IP address, a FQDN, an email address or a distinguished
# name. This value has to be the same as IPSEC_REMOTEID on the other side of
# the tunnel.
IPSEC_LOCALID=

# local network to be shared over the VPN tunnel
# used for leftid=
IPSEC_LOCALNET=

# public IP address of the remote node of the tunnel
IPSEC_REMOTEIP=

# remote network to be shared
IPSEC_REMOTENET=

# the remote identifier for the connection
IPSEC_REMOTEID=

# pre shared key to be used for the tunnel
# this should be a long random string
IPSEC_PSK=

# method of key exchange
# ike | ikev1 | ikev2
IPSEC_KEYEXCHANGE=

# comma-separated list of ESP encryption/authentication algorithms to be used for the connection
# see https://wiki.strongswan.org/projects/strongswan/wiki/IKEv1CipherSuites
# or https://wiki.strongswan.org/projects/strongswan/wiki/IKEv2CipherSuites
# depending on your value for IPSEC_KEYEXCHANGE.
# example: esp=aes192gcm16-aes128gcm16-ecp256,aes192-sha256-modp3072
IPSEC_ESPCIPHER=

# comma-separated list of IKE/ISAKMP SA encryption/authentication algorithms to be used
# see https://wiki.strongswan.org/projects/strongswan/wiki/IKEv1CipherSuites
# or https://wiki.strongswan.org/projects/strongswan/wiki/IKEv2CipherSuites
# depending on your value for IPSEC_KEYEXCHANGE.
# example: aes192gcm16-aes128gcm16-prfsha256-ecp256-ecp521,aes192-sha256-modp3072
IPSEC_IKECIPHER=

# how long a particular instance of a connection (a set of encryption/authentication keys for user packets)
# should last, from successful negotiation to expiry; acceptable values are an integer optionally followed by
# s (a time in seconds) or a decimal number followed by m, h, or d (a time in minutes, hours,
# or days respectively) (default 1h, maximum 24h).
IPSEC_LIFETIME=

# how long the keying channel of a connection (ISAKMP or IKE SA) should last before being renegotiated.
# Default: 3h
IPSEC_IKELIFETIME=

# Force UDP encapsulation for ESP packets even if no NAT situation is detected.
# *yes* | no
IPSEC_FORCEUDP=

# Whether rekeying of an IKE_SA should also reauthenticate the peer.
# *yes* | no
IPSEC_IKEREAUTH=

# Interfaces to bind Charon to
# If not set, it will bind to all interfaces
# Comma seperated list (e.g. eth0,eth1,eth2)
IPSEC_INTERFACES=eth0

# uncomment the debug flag for additional debugging output
# DEBUG=yes
