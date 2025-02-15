#!/bin/bash

# Preconfigurar Postfix
echo "postfix postfix/mailname string mail.aula.izv" | debconf-set-selections
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar paquetes
apt-get update && apt-get upgrade -y
apt-get install -y \
    bind9 postfix dovecot-imapd dovecot-pop3d \
    apache2 php libapache2-mod-php php-imap

# Configurar DNS (Bind9)
cp /etc/bind/extra/named.conf.local /etc/bind/
cp /etc/bind/extra/db.aula.izv /etc/bind/
cp /etc/bind/extra/db.192.168.33 /etc/bind/
systemctl restart bind9

# Configurar Postfix
cp /etc/postfix/extra/main.cf /etc/postfix/
systemctl restart postfix

# Configurar Dovecot
cp /etc/dovecot/extra/10-mail.conf /etc/dovecot/conf.d/
cp /etc/dovecot/extra/10-auth.conf /etc/dovecot/conf.d/
systemctl restart dovecot

# Configurar Apache
cp /etc/apache2/extra/mail.conf /etc/apache2/sites-available/
a2ensite mail
a2dissite 000-default
systemctl reload apache2

# Configurar FQDN e IP
echo "192.168.33.10 mail.aula.izv mail" >> /etc/hosts
echo "mail.aula.izv" > /etc/hostname