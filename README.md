# Webmail Vagrant Setup

## Overview
This Vagrant setup provides a complete mail server environment using Postfix, Dovecot, Apache, and SquirrelMail. It simulates a private mail system with DNS services for testing purposes.

## Directory Structure & File Descriptions
```
webmail-vagrant/
├── Vagrantfile                # Configures the VM, including networking and provisioning
├── bootstrap.sh               # Installs essential services like Postfix, Dovecot, and Apache
├── config/                    # Stores configuration files for all services
│   ├── bind/                  # DNS settings
│   │   ├── named.conf.local   # Defines DNS zones
│   │   ├── db.aula.izv        # Forward DNS zone mapping domain names to IPs
│   │   └── db.192.168.33      # Reverse DNS zone mapping IPs to domain names
│   ├── postfix/               # Mail server configuration
│   │   └── main.cf            # Postfix settings (hostname, relay options, etc.)
│   ├── dovecot/               # IMAP/POP3 server settings
│   │   ├── 10-mail.conf       # Defines mail storage location
│   │   └── 10-auth.conf       # Authentication settings
│   ├── apache/                # Web server configuration
│   │   └── mail.conf          # Sets up Apache to serve SquirrelMail
└── scripts/
    └── configure-squirrelmail.sh  # Installs and configures SquirrelMail
```

## Prerequisites
- Install **Vagrant** and **VirtualBox**
- Ensure `vagrant` is available in your system’s PATH

## Getting Started
### 1. Start the Virtual Machine
Run this command inside the project directory:
```sh
vagrant up
```
This will create and configure the VM with all necessary services.

### 2. Connect to the VM
```sh
vagrant ssh
```

### 3. Access SquirrelMail
Open your browser and go to:
```
http://192.168.33.10
```
or
```
http://mail.aula.izv
```

### 4. Verify Mail Services
#### **Check Postfix (SMTP)**
```sh
telnet localhost 25
```
Expected response:
```
220 mail.aula.izv ESMTP Postfix
```

#### **Check Dovecot (IMAP)**
```sh
telnet localhost 143
```
Expected response:
```
* OK Dovecot ready.
```

### 5. Configure an Email Client
| Setting      | Value                         |
|-------------|------------------------------|
| IMAP Server | `192.168.33.10` or `mail.aula.izv` |
| IMAP Port   | `143` (STARTTLS) or `993` (SSL) |
| SMTP Server | `192.168.33.10` or `mail.aula.izv` |
| SMTP Port   | `25` (STARTTLS) or `587` (TLS) |
| Username    | Your Linux system username |
| Password    | Your system password |

## Troubleshooting
### Restart Services
```sh
sudo systemctl restart apache2 postfix dovecot
```

### View Logs
```sh
sudo tail -f /var/log/mail.log
```

### Check Open Ports
```sh
sudo netstat -tulnp | grep -E "25|143|587|993"
```

## Reset the VM
To start fresh:
```sh
vagrant destroy -f && vagrant up
```

---
This setup is designed for local testing and learning purposes.

