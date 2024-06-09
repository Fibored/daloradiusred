# About

[daloRADIUS](http://www.daloradius.com) is an advanced RADIUS web management application aimed at managing hotspots and
general-purpose ISP deployments. It features user management, graphical reporting, accounting,
a billing engine and integrates with GoogleMaps for geo-locating.

daloRADIUS is written in PHP and JavaScript and utilizes a database abstraction
layer which means that it supports many database systems, among them the popular
MySQL, PostgreSQL, Sqlite, MsSQL, and many others.

It is based on a [FreeRADIUS](http://www.freeradius.org) deployment with a database server serving as the backend.
Among other features it implements ACLs, GoogleMaps integration for locating
hotspots/access points visually and many more features.

## Contributors

Thanks goes to these wonderful people :

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
<table><tr><td align="center"><a href="https://github.com/liran_tal"><img src="https://avatars1.githubusercontent.com/u/316371?v=4" width="100px;" alt="Liran Tal"/><br /><sub><b>Liran Tal</b></sub></a><br /></td><td align="center"><a href="https://github.com/MiguelVis"><img src="https://avatars0.githubusercontent.com/u/4165032?s=460&v=4" width="100px;" alt="MiguelVis"/><br /><sub><b>MiguelVis</b></sub></a><br /></td><td align="center"><a href="https://github.com/screwloose8"><img src="https://avatars0.githubusercontent.com/u/18901582?s=460&v=4" width="100px;" alt="screwloose83"/><br /><sub><b>screwloose83</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/AxeyGabriel"><img src="https://avatars1.githubusercontent.com/u/6699637?s=460&v=4" width="100px;" alt="Axey Gabriel Müller Endres
"/><br /><sub><b>screwloose83</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/zanix"><img src="https://avatars2.githubusercontent.com/u/1580378?s=460&v=4" width="100px;" alt="Joshua Clark"/><br /><sub><b>Joshua Clark</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/theFra985"><img src="https://avatars2.githubusercontent.com/u/16063131?s=460&v=4" width="100px;" alt="Francesco Cattoni"/><br /><sub><b>Francesco Cattoni</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/Tantawi"><img src="https://avatars2.githubusercontent.com/u/1369523?s=460&v=4" width="100px;" alt="Mohamed Eltantawi"/><br /><sub><b>Mohamed Eltantawi</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/Seazonx"><img src="https://avatars1.githubusercontent.com/u/41646287?s=460&v=4" width="100px;" alt="Seazon"/><br /><sub><b>Seazon</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/reigelgallarde"><img src="https://avatars3.githubusercontent.com/u/10612336?s=400&v=4" width="100px;" alt="Reigel Gallarde"/><br /><sub><b>Reigel Gallarde</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/jomaxro"><img src="https://avatars0.githubusercontent.com/u/15638256?s=400&v=4" width="100px;" alt="Joshua Rosenfeld"/><br /><sub><b>Joshua Rosenfeld</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/seanmavley"><img src="https://avatars2.githubusercontent.com/u/5289083?s=400&v=4" width="100px;" alt="Nkansah Rexford"/><br /><sub><b>Nkansah Rexford</b></sub></a><br /></td>
	<td align="center"><a href="https://github.com/dennisdegreef"><img src="https://avatars0.githubusercontent.com/u/361905?s=400&v=4" width="100px;" alt="Dennis de Greef"/><br /><sub><b>Dennis de Greef</b></sub></a><br /></td>
	</tr></table>
<!-- ALL-CONTRIBUTORS-LIST:END -->

# Instalacion de daloradius en Almalinux 8
- Se necesita un vps con Almalinux instalado
- Access para impresion de fichas, **no necesario**, puedes usar `https://github.com/wirisp/printdalo` en el mismo servidor.
- Mysql Workbench para checar tiempos y exportar las fichas/vouchers a excel , **no necesario**, si utilizas directamente `https://github.com/wirisp/printdalo`
-  Se realizara una instalacion limpia en almalinux, si la instancia se conecta por ssh solamente, se le otorgara acceso por usuario/contraseña root para poder administrar desde Mysql Workbench la base de datos y exportarla a excel. (Access y Mysql workbench se usa para checar los usuarios en tiempos e imprimir las fichas/vouchers)
-En este tutoria se utilizara en vez del puerto 22 el puerto 6813 para acceso por ssh, por lo que debera abrirse en la administracion del vps, aunque alternativamente puedes usar el 22 solamente ignora la parte del cambio de puerto.**puedes omitir el cambio de puerto**
- Creacion de perfiles y planes tiempos ; Perfiles/grupos= manejo de tiempos de usuario, plan=costos del perfil o ficha individual,conteo.
	- 2 Horas Pausadas
	- 12 Horas Corridas
	- Cliente-mensual recurrente
	- Cliente ppoe
- Acceso por Mysql Workbench a la base de datos y exportacion de un lote de fichas a excel.
- Impresion del lote de fichas importadas desde Mysql Workbench -->excel--> Access.
- Contraseña usada en este tutorial para root,mysql y archivo daloradius.conf.php es *84Uniq@*.
# Selinux permisive
```
sudo su
```
```
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
```
# Acceso root con usuario y contraseña en instancia.

 * Instalamos nano
 ```
dnf makecache --refresh
 ```
 ```
dnf install nano -y
 ```
 * En el archivo **/etc/cloud/cloud.cfg** agregar el usuario *root* (este archivo esta disponible en algunas instancias ,omitir si no)
 
 ```
 sudo nano /etc/cloud/cloud.cfg
 ```
 *Agregamos el usuario root*
 ```
 users:
   - default
   - root
 ```
 * Modificar las lineas siguientes, deben quedar asi.
 ```
 disable_root: false
 ssh_pwauth:   true
 #disable_root: 1
 #ssh_pwauth:   0
 ```
 _En ocasiones hay un numero 0 ,1, significa `0=true` y `1=false`._
## Cambio del puerto 22 a 6813 
* Editar el archivo */etc/ssh/sshd_config* y colocar/modificar las lineas a:
```
nano /etc/ssh/sshd_config
```
*Modificamos el archivo a:*
```
Port 6813 
PermitRootLogin yes
PasswordAuthentication yes
```
- Cambiamos el password del root
```
sudo su
passwd root
# 84Uniq@
```
## Reglas de firewall para el puerto 6813
* Instalacion paquete necesario firewalld
```
dnf install firewalld -y
systemctl enable --now firewalld
```
* Puerto a abrir 6813

```
dnf install -y policycoreutils-python-utils
```
Despues
```
semanage port -a -t ssh_port_t -p tcp 6813
firewall-cmd --zone=public --add-port=6813/tcp --permanent
```
* Checar que la linea del archivo */etc/firewalld/firewalld.conf* queden en no.
`nano /etc/firewalld/firewalld.conf`
*Dentro buscar la linea AllowZoneDrifting=yes y cambiarla a no*
```
AllowZoneDrifting=no
```
* Reiniciar servicio firewalld y sshd
```
systemctl restart firewalld
firewall-cmd --reload
systemctl restart sshd
```

* Colocarle contraseña al usuario root

```
passwd root
```
```
sudo service sshd restart
#Salir con
exit
exit
```
* Ingresar desde terminal  con
```
ssh -p6813 root@IP
```
* Borrar la parte de la ssh que no se usara ,todo antes de ssh-rsa de la clave ssh `no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command="echo 'Please login as the user \"opc\" rather than the user \"root\".';echo;sleep 10;exit 142"`, ya que eso impide el acceso por ssh con la clave de acceso.
```
sudo su
```
```
cd /root/.ssh
nano authorized_keys
```
* Guardar y reiniciar con
```
sudo service sshd restart
```
* Ahora podemos ingresar por ssh o por ip
Cambiamos los datos de la terminal por ssh entrar en el puerto `6813` en lugar del 22 y con usuario `root`

## Actualizacion, selinux permisivo y paquetes a instalar
```language
sudo su
```
```
dnf makecache --refresh
```

- Le damos `reboot` a la maquina


## Preparacion de equipo y repositorios
```
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
```
* Instalacion de modulos php,httpd,cli,curl....
```
dnf module enable php:remi-7.4 -y
```
```
dnf -y install @httpd @php
```
```
dnf -y install php-{cli,curl,mysqlnd,devel,gd,pear,mbstring,xml,pear}
```
```
dnf install firewalld -y
```
* Instalacion de PEAR, DB y MDB2

```
dnf -y install php-pear
```
```
sudo pear install DB
sudo pear install MDB2
pear channel-update pear.php.net
```
* Activacion de servicios httpd php firewalld
```
systemctl enable --now httpd php-fpm
systemctl enable --now firewalld
```
* Agregar servicios http https radius ntp
```
firewall-cmd --add-service={http,https,radius,ntp} --permanent
firewall-cmd --reload
```
* Instalacion y activacion de servicio Mariadb
```
dnf module install mariadb -y
systemctl enable --now mariadb
```
* Agregar contraseña a Mysql, cuando pregunte si se desea desactivar remotamente colocar *n* de no, la contraseña usada en este tutorial es *84Uniq@*.
```
mysql_secure_installation
# enter
# Disallow root login remotely? [Y/n] n
# password usada aqui es 84Uniq@
```
* creacion de db aqui la contraseña que use es *84Uniq@* procura cambiarla
```
mysql -u root -p
CREATE DATABASE radius;
GRANT ALL ON radius.* TO radius@localhost IDENTIFIED BY "84Uniq@";
FLUSH PRIVILEGES;
quit;
```
# Instalacion y configuracion de freeradius
* Instalamos los siguientes paquetes y activamos, tambien creamos un acceso simbolico
```
dnf install -y @freeradius freeradius-utils freeradius-mysql
```
```
systemctl enable --now radiusd
```
```
mysql -u root -p radius < /etc/raddb/mods-config/sql/main/mysql/schema.sql
```
```
ln -s /etc/raddb/mods-available/sql /etc/raddb/mods-enabled/
```

* Para remplazar los archivos por los del tutorial, debemos descargar una carpeta que los contiene
```
dnf install -y git
```
```
git clone https://github.com/wirisp/daloup.git
```
* Remplazamos el archivo *sql* , cambiale la contraseña usada password= `84Uniq@` por la tuya

```
\mv /root/daloup/sql /etc/raddb/mods-available/sql
nano /etc/raddb/mods-available/sql
```
* Aplicamos permisos y reiniciamos servicio
```
chgrp -h radiusd /etc/raddb/mods-enabled/sql
systemctl restart radiusd
```
# Instalacion y configuracion de Daloradius

```
git clone https://github.com/wirisp/daloradius.git
```
* Entramos a la carpeta
```
cd daloradius
```
* Lanzamos los siguientes comandos recordando la contraseña que le pusimos.
```
mysql -u root -p radius < contrib/db/fr2-mysql-daloradius-and-freeradius.sql
```
* Despues este otro
```
mysql -u root -p radius < contrib/db/mysql-daloradius.sql
```
* Salimos a una carpeta anterior con
```
cd ..
```
* Movemos el directorio a /var/www/html
```
mv daloradius /var/www/html/
```
* Copiamos uno de los archivos que descargamos, recuerda cambiarle el password por el tuyo el usado en este archivo es *84Uniq@*.
```
\mv /root/daloup/daloradius.conf.php /var/www/html/daloradius/library/daloradius.conf.php
nano /var/www/html/daloradius/library/daloradius.conf.php
```
* Aplicamos permisos y reiniciamos servicio
```
chown -R apache:apache /var/www/html/daloradius/
chmod 664 /var/www/html/daloradius/library/daloradius.conf.php
systemctl restart radiusd.service httpd
```
* Cambiar el timezone al que usaremos, tambien instalamos chrony
```
dnf install chrony -y
```
```
systemctl enable --now chronyd
firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload
#Para mi es America/Mexico_City
timedatectl set-timezone America/Mexico_City
```
* Instalamos php-dba y policycoreutils
```
dnf install -y policycoreutils-python-utils
```
```
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/daloradius(/.*)?"
restorecon -Rv /var/www/html/daloradius
dnf -y install php-dba
```
* Aplicamos permisos a unos directorios necesarios de logs y creamos uno nuevo tambien
```
chmod 755 /var/log/radius/
chmod 644 /var/log/radius/radius.log
chmod 644 /var/log/messages
#chmod 644 /var/log/dmesg
touch /tmp/daloradius.log
```
* el archivo radiusd.conf , yo le hare backup y colocare el mio
```
\mv /root/daloup/radiusd.conf /etc/raddb/radiusd.conf
```
* Modificamos el archivo /etc/raddb/sites-enabled/default  yo le colocare el que descargue
```
\mv /root/daloup/default /etc/raddb/sites-enabled/default
```

* Modificamos el archivo  /etc/raddb/mods-available/sqlcounter ,yo le pondre el que descargue.
```
\mv /root/daloup/sqlcounter /etc/raddb/mods-available/sqlcounter
```
* Modificar el archivo /etc/raddb/mods-config/sql/counter/mysql/access_period.conf o colocarle el que he subido
```
\mv /root/daloup/access_period.conf /etc/raddb/mods-config/sql/counter/mysql/access_period.conf
```
* Modificar el archivo /etc/raddb/mods-config/sql/counter/mysql/quotalimit.conf o colocarle el descargado
```
\mv /root/daloup/quotalimit.conf /etc/raddb/mods-config/sql/counter/mysql/quotalimit.conf
```
* Modificar el archivo /etc/raddb/mods-enabled/radutmp o pasarle el descargado...
```
\mv /root/daloup/radutmp /etc/raddb/mods-enabled/radutmp
```
* Modificar el archivo  /etc/raddb/mods-config/sql/main/mysql/queries.conf o colocarle el descargado
```
\mv /root/daloup/queries.conf /etc/raddb/mods-config/sql/main/mysql/queries.conf
```
* Modificar el archivo php.conf o enviar el propio,tambien el index.php
```
\mv /root/daloup/php.conf /etc/httpd/conf.d/php.conf
\mv /root/daloup/index.php /var/www/html/index.php
```
* En radius.service comentar *ExecStartPre=-/bin/sh /etc/raddb/certs/bootstrap* colocarle un #
```
nano /usr/lib/systemd/system/radiusd.service
```
* Importante subir esquema de la base de datos ---->>>
```
cd daloup
```
* Enviar sql descargado importante
```
mysql -p -u root radius < /root/daloup/dbname.sql
```
* Iniciar servicio
```
systemctl stop radiusd
systemctl daemon-reload
systemctl start radiusd
systemctl status radiusd
```
* Reiniciar sistema completo 
acceder desde IP/daloradius con usuario `administrator` y password `radius` o `84Uniq@`
* Para analisis puede usar
```
systemctl status radiusd
systemctl stop radiusd
radiusd -X
systemctl start radiusd
```
_Es necesario que se abran los puertos en el vps de administracion `1812,1813,3306,6813,80,8080,443`_
# Respaldar directorio /var/www/html/daloradius
```
cd /var/www/html/daloradius/
tar -cvpzf daloradius.tar .
```
* Descomprimir con
```
cd /var/www/html/daloradius
tar -xvf daloradius.tar
```
* Acceso por medio de la interfaz web a daloradius
```
http://IP/daloradius/index.php
USUARIO= administrator
PASSWORD= radius
```
# Agregar memoria swap de 8Gb
```
sudo fallocate -l 8G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
top
```
# Acceder por ssh con usuario y contraseña con el puerto 6813
```
ssh -p6813 root@IP 
```
# Conexion por MYSQL workbench con los datos de este tutorial
- instalar mysql workbench
```
standar tcp/ip over ssh
IP:6813
ssh username= root 
ssh password= 84Uniq@
mysql hostname= 127.0.0.1
mysql server port=3306
username=root   
default schrema=radius 
```

# Creacion de perfiles/grupos y planes
### 2 HORAS TIEMPO PAUSADO==========> NOMBRE DEL PERFIL/GRUPO= 2HPAUSADO
        
        LOS ATRIBUTOS SON DEFINIDOS EN EL PERFIL 
        -    Max-All-Session  <check> = TIEMPO DEL VOUCHER EN SEGUNDOS 2HRS=7200
        -    WISPr-Bandwidth-Max-Up <Reply> = VELOCIDAD DE SUBIDA
        -    WISPr-Bandwidth-Max-Down <Reply> = VELOCIDAD DE BAJADA
        -    PARA CONTABILIDAD LLEVA UN PLAN ,AL CREAR LOS VOUCHERS SE SELECCIONA EL PLAN

### 12 HORAS TIEMPO CORRIDO==========>NOMBRE DEL PERFIL/GRUPO= 12HCORRIDO

        LOS ATRIBUTOS SON DEFINIDOS EN EL PERFIL
        - Access-Period <Check> = TIEMPO DEL VOUCHER EN SEGUNDOS 12HRS=43200
        -    WISPr-Bandwidth-Max-Up <Reply> = VELOCIDAD DE SUBIDA
        -    WISPr-Bandwidth-Max-Down <Reply> = VELOCIDAD DE BAJADA
        -    PARA CONTABILIDAD LLEVA UN PLAN ,AL CREAR LOS VOUCHERS SE SELECCIONA EL PLAN

### VOUCHER MENSUAL / PERSONALIZADO   =========> NOMBRE DEL PERFIL/GRUPO = MENSUAL

        SON CLIENTES MENSUALES QUE PUEDEN SER RECURRENTES, O SE LES PUEDE AGREGAR POR DIAS
        - ATRIBUTOS EN EL PERFIL SON.
                -    WISPr-Bandwidth-Max-Up <Reply> = VELOCIDAD DE SUBIDA
                -    WISPr-Bandwidth-Max-Down <Reply> = VELOCIDAD DE BAJADA
        - LOS ATRIBUTOS A CADA VOUCHER PERSONALIZADO POR EJEMPLO HOY ES 21/01/2023 Y QUIERO DARLE 15 DIAS.
        > NUEVO USUARIO 
        > NOMBRE = PRUEBA15 
        > CONTRASEÑA=123 
        > GRUPO= MENSUAL
        >> ATRIBBUTES > CUSTOM ATRIBUTE
        - WISPr-Session-Terminate-Time <Reply> = 2023-02-06T11:00:00
        - EL USUARIO SE LE TERMINARA EL ACCESO EL DIA 06/02/2023 A LAS 11:00 AM.
        - SI DESEO MODIFICAR LA FECHA SOLO BUSCO EL USUARIO Y MODIFICO EL ATRIBUTO.
        - PARA CONTABILIDAD NO LLEVA UN PLAN, NO SE LLEVA CONTROL YA QUE SON MANUALES Y RECURRENTES.

### CLIENTE PPOE

        LOS ATRIBUTOS SON.
        -    Mikrotik-Rate-Limit <rEPLY> = VELOCIDAD DE CONEXION
        -    Framed-Protocol = PPP
        AL CREAR EL USUARIO SE COLOCA
        -    Expiration <Check> = FECHA DE EXPIRACION = 10 Feb 2023
        -    Framed-Pool <Reply> = TIPO = pool_pppoe

* Prueba hacer un lote con uno de los perfiles.
* Prueba Agregar un NAS mikrotik, solo se realiza una vez
   - managment>NAS>new nas
   ```
  NAS IP/Host 0.0.0.0/0
  NAS Secret 84Uniq@
  NAS Type other
  NAS Shortname mikrotik
  ```
  - Managment >Hotspot  para agregar cada mikrotik
  - new hotspot
  ```
  Hotspot Name hAP
  MAC Address (es la mac ether1 en este caso de la wan donde recibe internet el mikrotik)
  ```
  * Prueba usar una ficha/voucher en el wifi mikrotik.
# IMPRESION DE VOUCHERS CON ACCESS EN WINDOWS
- USAR ACCESS CON EL ARCHIVO LOTES.ZIP.

## BUSCAR EL ID CORRESPONDIENTE AL LOTE X EN WORKBENCH
- EN WORKBENCH ---> CONECTAR DB ---> RESUMEN --->CALENDAR CON RAYO
- COLOCAR
```
SELECT * FROM radius.resumen;
```
- CHECAR EL ID POR EJEMPLO 26
## EXPORTAR LISTA DE FICHAS / VOUCHERS DE ESE LOTE
- EN WORKBENCH ---> CONECTAR DB ---> FICHAS --->CALENDAR CON RAYO
```
SELECT * FROM radius.fichas
where id in (26)
```
- DARLE CLICK EN RAYO 
- EXPORTARLAS A EXCEL
- COPIARLAS Y COLOCARLAS EN EL ACCESS PARA IMPRIMIR.

# BACKUP BASE DE DATOS MANUALMENTE
```
#backup db
mysqldump -p -u root radius > dbname.sql
```
### RESTAURAR BASE DE DATOS
```
#Restaurar
mysql -p -u root radius < dbname.sql
```
Ve a Ip/daloradius y cambia el **password del NAS**, despues reinicia el servicio o reinicia la maquina, para que surta efecto.
# BACKUP BASE DE DATOS AUTOMATICO Y CRONTAB
suponiendo que la carpeta es /root/backupdb/db.sh
```
mkdir backupdb
cd backupdb
nano db.sh
```
- Dentro de el archivo db.sh introducir lo siguiente, cambiando tu usuario y contraseña.
```
#! /bin/bash
username=root
password=84Uniq@
database=radius
now="$(date +'%d_%m_%Y_%H_%M_%S')"
filename="base_$now".gz
backupfolder="/root/backupdb/"
fullpathbackupfile="$backupfolder/$filename"
logfile="$backupfolder/"base_log_"$(date +'%Y_%m')".txt
echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --user=$username --password=$password $database > $fullpathbackupfile
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

echo "remove backup 5 days old" >> "$logfile"
# Delete files older than 5 days
find $backupfolder/* -mtime +5 -exec rm {} \;
echo "complete removing" >> "$logfile"
exit 0
#sudo chmod +x db.sh
#sudo ./db.sh
```
- Instalacion de cronie para el crontab , se ejecute automaticamente cada dia a las 10.05 am.
```
dnf install cronie -y
```
- Ahora con el siguiente abremos crontab
```
export VISUAL=nano; crontab -e
```
- Colocamos dentro la siguiente linea (10.05 am.), recuerda el directorio es donde esta el script db.sh
```
5 10 * * * /root/backupdb/db.sh
```
# COMANDOS EXTRAS
### Buscar texto dentro de archivos
```
grep -rl "texto aqui" /etc
```
### Eliminar todo el texto o la info del document.txt
```
echo > document.txt
```
### Copiar o mover todo al nuevo archivo,sin pedir confirmacion
```
\mv document.txt /var/www/html/document.txt
\cp -r document.txt /var/www/html/document.txt
```
# Copyright

Copyright Liran Tal 2007-2019. All rights reserved.
For release information and license, read LICENSE.

[daloRADIUS](http://www.daloradius.com) version 1.1-2 stable release
by Liran Tal <liran.tal@gmail.com>,
Miguel García <miguelvisgarcia@gmail.com>.


[daloRADIUS_Logo]: https://cloud.githubusercontent.com/assets/316371/7488472/87a11c08-f3d3-11e4-9a8e-96deafaf4d2f.png
[daloRADIUS_Feature_Management]: https://cloud.githubusercontent.com/assets/316371/7444436/48d887e4-f18b-11e4-855d-264dc6d881e1.jpg
[daloRADIUS_Feature_Accounting]: https://cloud.githubusercontent.com/assets/316371/7488564/9338bf0c-f3d4-11e4-977b-48227eb5c2b5.jpg
[daloRADIUS_Book]: https://cloud.githubusercontent.com/assets/316371/7488439/e3c9bd4c-f3d2-11e4-9d88-9f57098752e0.jpg
