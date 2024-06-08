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
2. Permitimos elacceso al vps con password
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
5. Instalacion de Mariadb

