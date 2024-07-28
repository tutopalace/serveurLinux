
## INFO : 
## Cette DOC avance au rythme des videos disponibles sur la chaine @tutopalace
## https://youtube.com/@tutopalace


### Pour Securiser la configuration d'un serveur Ubuntu Linux


# 1. Mise à jour du serveur  

	apt update && apt -y full-upgrade && apt -y clean && apt -y autoremove


# 2. Installation utilitaires (paquets)   

	apt install vim git net-tools ssh


# 3. Création user tutopalace  
Remplacer le user "tutopalace" par le user de ton choix   

	useradd -m -s /bin/bash tutopalace


# 3.1 Password user tutopalace
Remplacer le user "tutopalace" par le user de ton choix  

	passwd tutopalace


# 3.2 Ajout permission SUDO pour tutopalace 
Remplacer le user "tutopalace" par le user de ton choix  

````tutopalace.sudo

# /etc/sudoers.d/tutopalace
tutopalace ALL=(ALL) NOPASSWD: ALL

````

# 4.1 SShd - Configuration du serveur SSH
Remplacer le user "tutopalace" par le user de ton choix  
Remplacer le port:  port > 50000 (c'est mieux)  
Supprimer tous les autres fichiers dans /etc/ssh/sshd_config.d  
Penser à redémarrer le serveur SSH :    
systemctl restart ssh

````/etc/ssh/sshd_config.d/99-tutopalace.conf

    #/etc/ssh/sshd_config.d/99-tutopalace.conf
    # Attention: Remplace le user "tutopalace" 
    # et le port éventuellement 
    
    PermitRootLogin no
    PasswordAuthentication no
    PubkeyAuthentication yes
    Port 52222
    AllowUsers tutopalace
    LogLevel VERBOSE

````


# 4.2 ".ssh/config" - Configuration du client SSH 
Remplacer TOUS les champs par ta configuration  Host (alias), Hostname (ip), Port, User, IdentityFile 


````config

    #/home/tutopalace/.ssh/config

    Host      	    tutopalace.com  tp 
    HostName  	    192.168.1.200
    Port      	    52222
    User      	    tutopalace
    IdentityFile    ~/.ssh/id_rsa.uc

````


# 5.1 IPTABLES
Remplacer le user "tutopalace" par le user de ton choix  
Remplacer le port ssh (ici 52222 ) =>   port > 50000

````fw.sh
# /home/tutopalace/bin/fw.sh

    #!/bin/bash
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


    # /!\ A chaque execution du script => Sauvegarde configuration (Debian/Ubuntu) :
    sudo /usr/sbin/iptables-save > /etc/iptables/rules.v4
    sudo /usr/sbin/ip6tables-save > /etc/iptables/rules.v6

````




## Suite à venir avec video sur la chaine youtube.com/@tutopalace  ;-)


