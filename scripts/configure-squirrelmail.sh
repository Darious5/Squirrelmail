#!/bin/bash

# Descargar SquirrelMail
wget https://downloads.sourceforge.net/project/squirrelmail/stable/1.4.22/squirrelmail-webmail-1.4.22.tar.gz -P /tmp

# Descomprimir y enlazar
tar xvfz /tmp/squirrelmail-webmail-1.4.22.tar.gz -C /usr/local
ln -s /usr/local/squirrelmail-webmail-1.4.22 /var/www/mail

# Configurar directorios
mkdir -p /var/local/squirrelmail/{data,attach}
chown -R www-data:www-data /var/local/squirrelmail

# Copiar el archivo de configuración por defecto si no existe
CONFIG_FILE="/usr/local/squirrelmail-webmail-1.4.22/config/config.php"
if [ ! -f "$CONFIG_FILE" ]; then
    cp /usr/local/squirrelmail-webmail-1.4.22/config/config_default.php "$CONFIG_FILE"
fi

# Configurar SquirrelMail modificando config.php directamente:
# - Establece el dominio a "aula.izv"
# - Cambia el idioma por defecto a "es_ES"
# - Define el servidor IMAP (en este caso, "localhost")
sed -i 's/\$domain = .*/\$domain = "aula.izv";/' "$CONFIG_FILE"
sed -i 's/\$default_language = .*/\$default_language = "es_ES";/' "$CONFIG_FILE"
sed -i 's/\$imapServerAddress = .*/\$imapServerAddress = "localhost";/' "$CONFIG_FILE"

# Reiniciar servicios (asegúrate de que estén instalados)
systemctl restart apache2 dovecot postfix
