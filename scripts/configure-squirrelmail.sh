#!/bin/bash

# Synchronize system time to prevent SSL certificate errors
apt-get update
apt-get install -y ntp
service ntp stop
ntpdate pool.ntp.org
service ntp start

# Download SquirrelMail with error handling
wget https://downloads.sourceforge.net/project/squirrelmail/stable/1.4.22/squirrelmail-webmail-1.4.22.tar.gz -P /tmp || {
    echo "Failed to download SquirrelMail"
    exit 1
}

# Verify the downloaded file exists
if [ ! -f /tmp/squirrelmail-webmail-1.4.22.tar.gz ]; then
    echo "Downloaded file not found!"
    exit 1
fi

# Extract and link
tar xvfz /tmp/squirrelmail-webmail-1.4.22.tar.gz -C /usr/local || {
    echo "Failed to extract archive"
    exit 1
}

ln -s /usr/local/squirrelmail-webmail-1.4.22 /var/www/mail

# Configure directories
mkdir -p /var/local/squirrelmail/{data,attach}
chown -R www-data:www-data /var/local/squirrelmail

# Handle configuration file
CONFIG_DIR="/usr/local/squirrelmail-webmail-1.4.22/config"
CONFIG_FILE="$CONFIG_DIR/config.php"

# Ensure config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Configuration directory missing!"
    exit 1
fi

# Create config file from default if missing
[ -f "$CONFIG_FILE" ] || cp "$CONFIG_DIR/config_default.php" "$CONFIG_FILE"

# Modify configuration
sed -i 's/\$domain = .*/\$domain = "aula.izv";/' "$CONFIG_FILE"
sed -i 's/\$default_language = .*/\$default_language = "es_ES";/' "$CONFIG_FILE"
sed -i 's/\$imapServerAddress = .*/\$imapServerAddress = "localhost";/' "$CONFIG_FILE"

# Restart services
systemctl restart apache2 dovecot postfix