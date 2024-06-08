# daloradiusred
Sistema daloradius con algunas modificaciones en sus archivos para mejorarlo, tambien se dan instrucciones de scripts adicionales para eliminar fichas o vouchers pausados y corridos.
## Changelog
2024-04-22 Creacion del repositorio
## Guia Instalacion daloradius en Debian 11
1. Activar ipv6
```
enable_ipv6
sysctl -p
```
En `cat /etc/sysctl.conf` deveria estar `net.ipv6.conf.all.disable_ipv6 = 0` en el archivo.

2. Permitimos el acceso al vps con password
_Abrimos el archivo a modificar con nano_
```
nano /etc/ssh/sshd_config
```
_Dejamos las siguientes lineas a yes_
```
PermitRootLogin yes
PasswordAuthentication yes
```
3. Elegimos una clave para nuestro usuario root y reiniciamos los servicios
```
passwd root
```
_Despues de cambiar nuestro password,reiniciamos los servicios_
```
service ssh restart
systemctl restart sshd
```
4. Instalamos algunos paquetes necesarios para daloradius
```
apt -y install software-properties-common gnupg2 dirmngr git wget zip unzip sudo
```
_Seguimos con los siguientes_
```
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
```
_Terminada de instalar la clave agregamos un repositorio_
```
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.rackspace.com/mariadb/repo/10.5/debian bullseye main'
```
_Actualizamos el Sistema_
```
apt -y update
```
5. Instalacion de Mariadb, agregar linea por linea al terminal.
```
apt install mariadb-server mysqltuner -y
systemctl start mysql.service
mysql_secure_installation
```
Te apareceran algunas opciones de configuracion.
```
# enter
# Disallow root login remotely? [Y/n] n
# password usada aqui es 84Uniq@ ,utiliza el tuyo
```
- Creamos una base de datos, cambiamos `84Uniq@` por tu clave
```
mysql -u root -p
CREATE DATABASE radius;
GRANT ALL ON radius.* TO radius@localhost IDENTIFIED BY "84Uniq@";
FLUSH PRIVILEGES;
quit;
```
6. Instalacion de apache server ( si hay instalado lighttpd deshabilitarlo `systemctl disable lighttpd` )
```
apt -y install apache2
apt -y install php libapache2-mod-php php-{gd,common,mail,mail-mime,mysql,pear,mbstring,xml,curl}
apt -y install freeradius freeradius-mysql freeradius-utils
systemctl enable --now freeradius.service
mysql -u root -p radius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql
ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/
```

- Clonamos este repositorio para usar sus carpetas.

```
git clone https://github.com/wirisp/daloradius-debian11.git daloradius-debian11
```

- Movemos la carpeta daloradius a html del servidor
```
\mv /root/daloradius-debian11/daloradius /var/www/html/
```

- Remplazamos unos archivos por algunos editados, puedes hacer una comparacion de cambios con algun software en linea, en el mismo archivo hay una leyenda donde se cambio que dice: Wirisp cambiar aqui.

```
\mv /root/daloradius-debian11/daloup/radiusd.conf /etc/freeradius/3.0/radiusd.conf
\mv /root/daloradius-debian11/daloup/exten-radius_server_info.php /var/www/html/daloradius/library/exten-radius_server_info.php
\mv /root/daloradius-debian11/daloup/default /etc/freeradius/3.0/sites-enabled/default
\mv /root/daloradius-debian11/daloup/sqlcounter /etc/freeradius/3.0/mods-available/sqlcounter
\mv /root/daloradius-debian11/daloup/access_period.conf /etc/freeradius/3.0/mods-config/sql/counter/mysql/access_period.conf
\mv /root/daloradius-debian11/daloup/quotalimit.conf /etc/freeradius/3.0/mods-config/sql/counter/mysql/quotalimit.conf
\mv /root/daloradius-debian11/daloup/eap /etc/freeradius/3.0/mods-available/eap
\mv /root/daloradius-debian11/daloup/queries.conf /etc/freeradius/3.0/mods-config/sql/main/mysql/queries.conf
\mv /root/daloradius-debian11/daloup/radutmp /etc/freeradius/3.0/mods-enabled/radutmp
\mv /root/daloradius-debian11/daloup/sql /etc/freeradius/3.0/mods-available/sql
\mv /root/daloradius-debian11/daloup/daloradius.conf.php /var/www/html/daloradius/library/daloradius.conf.php
```

- Damos permisos necesarios
```
chgrp -h freerad /etc/freeradius/3.0/mods-available/sql
chown -R freerad:freerad /etc/freeradius/3.0/mods-enabled/sql
chown -R www-data:www-data /var/www/html/daloradius/
chmod 664 /var/www/html/daloradius/library/daloradius.conf.php
```


## Instalacion de Daloradius
```
cd /var/www/html/daloradius/
```

```
mysql -u root -p radius < contrib/db/fr2-mysql-daloradius-and-freeradius.sql
```

```
mysql -u root -p radius < contrib/db/mysql-daloradius.sql
```

- Regresamos a root
```
cd
```

- Editamos el archivo, cambiando el password `84Uniq@`

```
nano /etc/freeradius/3.0/mods-enabled/sql
```

```
nano /var/www/html/daloradius/library/daloradius.conf.php
```

- Colocamos zona horaria

```
timedatectl set-timezone America/Mexico_City
```

- Instalamos pear

```
pear install DB
pear install MDB2
pear channel-update pear.php.net
```


- Restauramos base de datos

```
mysql -p -u root radius < /root/daloradius-debian11/daloup/base.sql
```

- reiniciamos los servicios
```
systemctl restart apache2 freeradius
systemctl status apache2
systemctl status freeradius
```

- Darle permisos a carpetas log
```
chmod 777  /var/log/syslog
chmod 777 /var/log/freeradius
#chmod 755 /var/log/radius/
#chmod 644 /var/log/radius/radius.log
chmod 644 /var/log/messages
#chmod 644 /var/log/dmesg
touch /tmp/daloradius.log
```

- Reiniciar sistema e ingresar

```
reboot
```
- Ingresar a daloradius por la direccion `http://IP/daloradius` con usuario `administrator` y clave  `84Uniq@`
_Si hay error de puertos Es necesario que se abran los puertos en el vps de administracion 1812,1813,3306,6813,80,8080,443_
