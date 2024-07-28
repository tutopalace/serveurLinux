
# IPTABLES - Juste l'essentiel !
# GITHUB:  git clone http://github.com/tutopalace/tp 


1. IPTABLES => NFTABLES   (NETFILTER)
2. IPTABLES comprend quatre tables nommées :   
        
        mangle, [filter], nat, raw.


# Nous on ne s'intéresse qu'à la table "filter" 

# On efface tout !
### Remove all  
    iptables -F
    iptables -X

# Notion de politique par défaut !
### Bloquer tout par défaut et ouvrir en fonction des besoins

### Politics
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -P FORWARD DROP


# Autoriser un port !
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT


# Autoriser plusieurs ports 
### fichier moins long et plus lisible

### DNS, HTTP, HTTPS, SSH (TCP)
    iptables -A INPUT -p tcp -m multiport --dport 53,80,443,22 -j ACCEPT

### DNS, HTTP, HTTPS, SSH (UDP)
    iptables -A INPUT -p udp -m multiport --dport 53,80,443,123,22 -j ACCEPT


# 2 choses à ajouter : 

### Boucle locale (lo: 127.0.0.1 - localhost  ): 
    iptables -t filter -A INPUT -i lo -j ACCEPT
    iptables -t filter -A OUTPUT -o lo -j ACCEPT

### Etat (state)
    iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


### Même chose pour IPv6

    ip6tables -F
    ip6tables -X

    ### Politics
    ip6tables -P INPUT DROP
    ip6tables -P OUTPUT DROP
    ip6tables -P FORWARD DROP

    ### lo: 
    ip6tables -t filter -A INPUT -i lo -j ACCEPT
    ip6tables -t filter -A OUTPUT -o lo -j ACCEPT

    ### Etat (state)
    ip6tables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    ip6tables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT



# Sauvegarder les règles (Ubuntu/Debian) après reboot: 
    iptables-save > /etc/iptables/rules.v4
    ip6tables-save > /etc/iptables/rules.v6



# Autres actions : 

## Lister les règles avec numéro de ligne  
    iptables -L -vn --line-number

## Suppression d'une ligne (impose le numéro)  
    iptables -D INPUT 4

## Bannir une IP   
    iptables -A INPUT -s 10.0.0.1 -j DROP

