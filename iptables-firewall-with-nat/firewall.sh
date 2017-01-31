#!/bin/bash

# Define variables.
WAN=enp2s0
LAN_IP=192.168.0.0/255.255.0.0
LAN=wlx000df095f7c2
IPTABLES=/sbin/iptables
IP6TABLES=/sbin/ip6tables

# Load NAT-module.
/sbin/modprobe iptable_nat

# Load PPTP
/sbin/modprobe nf_conntrack_proto_gre
/sbin/modprobe nf_nat_proto_gre
/sbin/modprobe nf_conntrack_pptp
/sbin/modprobe nf_nat_pptp

# Enable port forwarding
/bin/echo 1 > /proc/sys/net/ipv4/ip_forward

###############
# BASIC TABLE #
###############

# Clean up all the rules.
${IPTABLES} -F
${IPTABLES} -Z
${IPTABLES} -X

# Basic rules, allow forwarding and outgoing and drop everything else.
${IPTABLES} -P FORWARD ACCEPT
${IPTABLES} -P INPUT DROP
${IPTABLES} -P OUTPUT ACCEPT

# Allow local area networking.
${IPTABLES} -A INPUT -i lo -j ACCEPT
${IPTABLES} -A OUTPUT -o lo -j ACCEPT
${IPTABLES} -A INPUT -i ${LAN} -s ${LAN_IP} -j ACCEPT

# Allow certain services from certain ip addresses.
${IPTABLES} -A INPUT -p tcp --dport 22 -m recent --set -s 88.0/8 -j ACCEPT              # SSH
${IPTABLES} -A INPUT -p tcp --dport 22 -m recent --set -s 91.0/8 -j ACCEPT              # SSH
#${IPTABLES} -A INPUT -p tcp --dport 25 -j ACCEPT                                       # SMTP (disallowed by ISP)
#${IPTABLES} -A INPUT -p tcp --dport 587 -j ACCEPT                                      # SMTP (disallowed by ISP)
${IPTABLES} -A INPUT -p tcp --dport 80 -j ACCEPT                                        # HTTP (IPV4)
${IP6TABLES} -A INPUT -p tcp --dport 80 -j ACCEPT                                       # HTTP (IPV6)
${IPTABLES} -A INPUT -p tcp --dport 993 -m recent --set -s 88.0/8 -j ACCEPT             # IMAPS
${IPTABLES} -A INPUT -p tcp --dport 993 -m recent --set -s 91.0/8 -j ACCEPT             # IMAPS
#${IPTABLES} -A INPUT -m recent --set -s 194.252.88.166 -j ACCEPT                       # YLE VPN (depricated)

# Override allow all to ports 22 143 443 993.
#${IPTABLES} -A INPUT -p tcp --dport 22 -j ACCEPT                                       # SSH
#${IPTABLES} -A INPUT -p tcp --dport 143 -j ACCEPT                                      # IMAP
#${IPTABLES} -A INPUT -p tcp --dport 443 -j ACCEPT                                      # HTTPS
#${IPTABLES} -A INPUT -p tcp --dport 993 -j ACCEPT                                      # IMAPS

# Deny traffic to private ports.
${IPTABLES} -A INPUT -i ${WAN} -p tcp --dport 0:1023 -j DROP
${IPTABLES} -A INPUT -i ${WAN} -p udp --dport 0:1023 -j DROP

# Deny SYN packages and ICMP traffic.
${IPTABLES} -A INPUT -i ${WAN} -p tcp --syn -j DROP
${IPTABLES} -A INPUT -i ${WAN} -p icmp -j DROP

# Allow returning traffic.
${IPTABLES} -A INPUT -i ${WAN} -p TCP -m state --state RELATED,ESTABLISHED -j ACCEPT
${IPTABLES} -A INPUT -i ${WAN} -p UDP -m state --state RELATED,ESTABLISHED -j ACCEPT

# Make sure to drop the rest.
${IPTABLES} -A INPUT -j DROP

#################
# ROUTING TABLE #
#################

# Allow forwarding Cisco VPN ports for Yle VPN (depricated).
#${IPTABLES} -A FORWARD -i ${WAN} -p udp --dport 500 -j ACCEPT
#${IPTABLES} -A FORWARD -i ${WAN} -p udp --dport 4500 -j ACCEPT
#${IPTABLES} -A FORWARD -i ${WAN} -p udp --dport 10000 -j ACCEPT
#${IPTABLES} -A FORWARD -i ${WAN} -p tcp --dport 10000 -j ACCEPT

# PPTP
${IPTABLES} -A FORWARD -i ${WAN} -p tcp --sport 1723 -j ACCEPT
${IPTABLES} -A FORWARD -i ${WAN} -p tcp --dport 1723 -j ACCEPT
${IPTABLES} -A FORWARD -p gre -j ACCEPT
${IPTABLES} -A FORWARD -p gre -j ACCEPT

# Deny forwarding traffict to private ports.
${IPTABLES} -A FORWARD -i ${WAN} -p tcp --dport 0:1023 -j DROP
${IPTABLES} -A FORWARD -i ${WAN} -p udp --dport 0:1023 -j DROP

# Deny forwarding SYN packages and ICMP traffic.
${IPTABLES} -A FORWARD -i ${WAN} -p tcp --syn -j DROP
${IPTABLES} -A FORWARD -i ${WAN} -p icmp -j DROP

# Allow forwarding returning traffic.
${IPTABLES} -A FORWARD -i ${LAN} -o ${WAN} -s ${LAN_IP} -j ACCEPT
${IPTABLES} -A FORWARD -i ${WAN} -o ${LAN} -d ${LAN_IP} -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
${IPTABLES} -A FORWARD -i ${WAN} -o ${LAN} -d ${LAN_IP} -p udp -m state --state RELATED,ESTABLISHED -j ACCEPT

# Make sure to drop the rest.
${IPTABLES} -A FORWARD -j DROP

#############
# NAT TABLE #
#############

# Clean up all the rules.
${IPTABLES} -t nat -F
${IPTABLES} -t nat -X

# Basic rules, allow everything.
${IPTABLES} -t nat -P PREROUTING ACCEPT
${IPTABLES} -t nat -P POSTROUTING ACCEPT
${IPTABLES} -t nat -P OUTPUT ACCEPT

# Make the postrouting rule.
${IPTABLES} -t nat -A POSTROUTING -o ${WAN} -j MASQUERADE

# Store changes
/sbin/ip6tables-save > /dev/null 2>&1
/sbin/iptables-save > /dev/null 2>&1
#/sbin/ip6tables-save
#/sbin/iptables-save