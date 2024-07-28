#!/bin/bash
# DOCUMENTATION des videos disponibles sur la chaine @tutopalace
# Sécuriser un serveur Ubuntu Linux  (Serveur privé virtuel Cloud, Raspberry Pi, ...) 
#
# youtube:	https://youtube.com/@tutopalace
# github: 	https://github.com/tutopalace/serveurLinux 
#
# IPTABLES
# /home/tutopalace/bin/fw.sh
# Remplacer le user "tutopalace" par le user de ton choix  
# Remplacer le port ssh (ici 52222 ) =>   si possible:  port > 50000


apt install iptables iptables-persitent 

/usr/sbin/iptables -F
/usr/sbin/iptables -X

## POLITICS
/usr/sbin/iptables -P INPUT DROP
/usr/sbin/iptables -P OUTPUT DROP
/usr/sbin/iptables -P FORWARD DROP

## lo
/usr/sbin/iptables -t filter -A INPUT -i lo -j ACCEPT
/usr/sbin/iptables -t filter -A OUTPUT -o lo -j ACCEPT

## state
/usr/sbin/iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
/usr/sbin/iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

## dns/53 - http/80 - https/443 - ssh/62222/tcp - ntp,timedatectl/123/udp
/usr/sbin/iptables -A INPUT -p tcp -m multiport --dport 80,443,52222 -j ACCEPT
/usr/sbin/iptables -A OUTPUT -p tcp -m multiport --dport 53,80,443,52222 -j ACCEPT

/usr/sbin/iptables -A INPUT -p udp -m multiport --dport 80,443,123 -j ACCEPT
/usr/sbin/iptables -A OUTPUT -p udp -m multiport --dport 53,80,443,123 -j ACCEPT

#################################################################################
# IPV6
#################################################################################

/usr/sbin/ip6tables -F
/usr/sbin/ip6tables -X

## POLITICS
/usr/sbin/ip6tables -P INPUT DROP
/usr/sbin/ip6tables -P OUTPUT DROP
/usr/sbin/ip6tables -P FORWARD DROP

## LO
/usr/sbin/ip6tables -t filter -A INPUT -i lo -j ACCEPT
/usr/sbin/ip6tables -t filter -A OUTPUT -o lo -j ACCEPT

## STATE
/usr/sbin/ip6tables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/usr/sbin/ip6tables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# /!\ A chaque execution du script /!\ 
# => Sauvegarde configuration (Debian/Ubuntu) :

sudo /usr/sbin/iptables-save > /etc/iptables/rules.v4
sudo /usr/sbin/ip6tables-save > /etc/iptables/rules.v6







