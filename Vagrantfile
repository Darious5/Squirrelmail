Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.hostname = "mail.aula.izv"
  config.vm.network "private_network", ip: "192.168.33.10"  # IP estática para el servidor

  # Sincronizar carpetas de configuración (excluding squirrelmail)
  config.vm.synced_folder "config/bind", "/etc/bind/extra"
  config.vm.synced_folder "config/postfix", "/etc/postfix/extra"
  config.vm.synced_folder "config/dovecot", "/etc/dovecot/extra"
  config.vm.synced_folder "config/apache", "/etc/apache2/extra"

  # Provisioning scripts
  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.provision "shell", path: "scripts/configure-squirrelmail.sh"
end
