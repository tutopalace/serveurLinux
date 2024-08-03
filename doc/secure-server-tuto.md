
# @tutopalace 2024
# [youtube.com/@tutopalace](https://youtube.com/@tutopalace)

> DOCUMENTATION des videos disponibles sur la chaine [@tutopalace](https://youtube.com/@tutopalace)


# Sécuriser la configuration d'un serveur Ubuntu Linux

> **WARNING** : 
> Le port ssh dans la doc est le 22,   
> n'oublier pas de le modifier avec : 
>  - un port > 50000 
>
> Le user est tutopalace, remplacer le : 
>  - Eviter noms communs et noms propres  
> - Préférer un vrai pseudo ayant aucune signification 

  

  

## 1. Mise à jour du serveur  

	apt update && apt -y full-upgrade && apt -y clean && apt -y autoremove


## 2. Installation utilitaires (paquets)   

	apt install vim git net-tools ssh tree nmap iptables iptables-persistent curl wget


## 3. Création user tutopalace  
Remplacer le user "tutopalace" par le user de ton choix   

	useradd -m -s /bin/bash tutopalace


## 3.1 Password user tutopalace
Remplacer le user "tutopalace" par le user de ton choix  

	passwd tutopalace


## 3.2 Ajout droits SUDO pour tutopalace 
Remplacer le user "tutopalace" par le user de ton choix  

````tutopalace.sudo

# /etc/sudoers.d/tutopalace
tutopalace ALL=(ALL) NOPASSWD: ALL

````


## 4.1 SSH - Génération des clés, copie sur le serveur et test  

> Création clé (si besoin)  

    ssh-keygen -f .ssh/id_rsa.tp -t rsa -b 4096           		# remplacer tp

> Copie de la clé publique sur le serveur  

    ssh-copy-id -i .ssh/id_rsa.tp.pub tutopalace@IP_SERVER		# remplacer tp, tutopalace, IP_SERVER

> Test de la clé  

    ssh -i .ssh/id_rsa.tp tutopalace@IP_SERVER				# remplacer tp, tutopalace, IP_SERVER



## 4.2 SSH - Configuration du client SSH 
> Remplacer TOUS les champs par ta configuration  Host (alias), Hostname (ip), Port, User, IdentityFile 

````config

    #/home/tutopalace/.ssh/config

    Host      	    tutopalace.com  tp 
    HostName  	    192.168.1.200
    Port      	    22				
    User      	    tutopalace
    IdentityFile    ~/.ssh/id_rsa.tp

````


## 4.3 SSHd - Configuration du serveur SSH
> Remplace le user "tutopalace" par le user de ton choix  
> Remplacer le port:  port > 50000 (c'est mieux)  
> Supprimer tous les autres fichiers dans /etc/ssh/sshd_config.d  
> Penser à redémarrer le serveur SSH :    
> systemctl restart ssh

````/etc/ssh/sshd_config.d/99-tutopalace.conf

#/etc/ssh/sshd_config.d/99-tutopalace.conf

PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 22                     	# A modifier port > 50000
AllowUsers tutopalace		# user à remplacer
LogLevel VERBOSE

````


> Redémarer SSH (attention au port)

    sudo systemctl restart ssh






## 5.1 Iptables
Remplace le user "tutopalace" par le user de ton choix  
Remplacer le port ssh (ici 22 ) =>   port > 50000

````fw.sh
#!/bin/bash
# /home/tutopalace/bin/fw.sh

apt install iptables iptables-persistent 

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
/usr/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/usr/sbin/iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## tcp: dns/53 - http/80 - https/443 - ssh/22/tcp - ntp,timedatectl/123/udp
/usr/sbin/iptables -A INPUT -p tcp -m multiport --dport 80,443,22 -j ACCEPT
/usr/sbin/iptables -A OUTPUT -p tcp -m multiport --dport 53,80,443,22 -j ACCEPT

## udp: dns/53 - http/80 - https/443 - ssh/22/tcp - ntp,timedatectl/123/udp
/usr/sbin/iptables -A INPUT -p udp -m multiport --dport 80,443,123 -j ACCEPT
/usr/sbin/iptables -A OUTPUT -p udp -m multiport --dport 53,80,443,123 -j ACCEPT

#############################################################
# IPV6
#############################################################

/usr/sbin/ip6tables -F
/usr/sbin/ip6tables -X

## POLITICS
/usr/sbin/ip6tables -P INPUT DROP
/usr/sbin/ip6tables -P OUTPUT DROP
/usr/sbin/ip6tables -P FORWARD DROP

## LO
#/usr/sbin/ip6tables -t filter -A INPUT -i lo -j ACCEPT
#/usr/sbin/ip6tables -t filter -A OUTPUT -o lo -j ACCEPT

## STATE
#/usr/sbin/ip6tables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#/usr/sbin/ip6tables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# /!\ A chaque execution du script /!\
#      => Sauvegarde configuration (Debian/Ubuntu)
#
# sudo /usr/sbin/iptables-save > /etc/iptables/rules.v4
# sudo /usr/sbin/ip6tables-save > /etc/iptables/rules.v6

````

> Redémarer iptables (attention au port)

    sudo systemctl restart iptables



## 6. fail2ban
Remplace le user "tutopalace" par le user de ton choix  

````jail.tutopalace.conf
# /etc/fail2ban/jail.d/jail.tutopalace.conf
    
[sshd]
enabled = true
port    = 22
bantime  = 1d
findtime  = 20m
maxretry = 3
banaction = iptables
banaction_allports = iptables[type=allports]
backend = systemd
    
````

> Redemarer fail2ban

    sudo systemctl restart fail2ban 



## 7. Fichier d'environnement :
> Un super fichier d'environnement à compléter !

```.tutopalace
# /home/tutopalace/.tutopalace

export EDITOR=vim
PS1='\[\033[01;32m\]\u\[\033[00m\]@\h:\[\033[01;34m\]\w\[\033[00m\] \$ '

alias sudo="sudo "
alias    s="sudo "

alias ls="ls --color=auto"
alias ll="ls -lh"
alias la="ls -a"
alias lla="ls -la"

alias grep="grep -E -i --color=auto"

# iptables
alias ipt="sudo iptables -L -vn --line-number"
alias ipt6="sudo ip6tables -L -vn --line-number"

# fail2ban
alias fbssh='sudo fail2ban-client status sshd'
alias fbban='sudo fail2ban-client set sshd banip ' 	#+IP
alias fbunban='sudo fail2ban-client set sshd unbanip ' 	#+IP


````

> Sourcer le fichier d'environnement    
> Ou mettre ce qui suit dans "$[HOME}/.profile"

    source .tutopalace 





## 9. Désactivez les comptes root, ubuntu

    sudo usermod -p '!' root
    sudo usermod -p '!' ubuntu

    le mieux étant : 
    sudo userdel ubuntu 



