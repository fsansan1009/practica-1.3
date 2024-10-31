#!/bin/bash

# Importa el archivo de variables de entorno
source .env

# Detiene la ejecución si hay un error
set -ex

# Elimina cualquier instalación previa en /tmp
rm -rf /tmp/iaw-practica-lamp

# Clona el repositorio de la aplicación
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

# Mueve el código fuente de la aplicación a la raíz web
mv /tmp/iaw-practica-lamp/src/* /var/www/html

# Actualiza el archivo de configuración de la aplicación con las variables del entorno
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

# Configura la base de datos
mysql -u root <<<"DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<<"CREATE DATABASE $DB_NAME"

# Crea el usuario y asigna permisos a la base de datos
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"

# Configura el archivo SQL con el nombre de la base de datos
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql

# Crea las tablas de la base de datos
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql
