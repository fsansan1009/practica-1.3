#!/bin/bash

# Detiene la ejecución si hay un error
set -ex

# Actualización de los repositorios
apt update

# Instalación del Servidor Apache
apt install apache2 -y

# Reinicio de Apache
sudo systemctl restart apache2

# Habilitación del módulo rewrite en Apache
a2enmod rewrite

# Copia el archivo de configuración a Apache
cp ../conf/000-default.conf /etc/apache2/sites-available

# Instalación de PHP y módulos necesarios
apt install php libapache2-mod-php php-mysql -y

# Instalación de MySQL Server
apt install mysql-server -y

# Reinicio de Apache después de la instalación de PHP y MySQL
sudo systemctl restart apache2

# Copia el archivo de prueba PHP a la raíz web
cp ../php/index.php /var/www/html

# Ajusta permisos en el directorio raíz de Apache
chown -R www-data:www-data /var/www/html
