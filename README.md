## Instalacion Daloradius en debian 11
1. Activar ipv6
```
enable_ipv6
sysctl -p
```
En `cat /etc/sysctl.conf` deveria estar `net.ipv6.conf.all.disable_ipv6 = 0` en el archivo.

Tambien deshabilitamos lighttpd para evitar error con apache.
```
systemctl stop lighttpd.service
systemctl disable lighttpd.service
```

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
apt -y install software-properties-common gnupg2 dirmngr git wget zip unzip sudo -y
```
_Seguimos con los siguientes_
```
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
```
_Terminada de instalar la clave agregamos un repositorio si estamos en debian 11, para 12 no es necesario_
```
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.rackspace.com/mariadb/repo/10.5/debian bullseye main'
```
_Actualizamos el Sistema_
```
apt -y update
```
5. Instalacion de Mariadb.
> [!CAUTION]
> El siguiente codigo lanzalo linea a linea osea uno a uno.
```
apt install mariadb-server mysqltuner -y
systemctl start mysql.service
mysql_secure_installation
```
Te apareceran algunas opciones de configuracion.
```
# enter
# Disallow root login remotely? [Y/n] n
# password usada aqui es 84Pass@ ,utiliza el tuyo, recuerda cuando veas 84Pass@ cambiarlo.
```
- Creamos una base de datos, cambiamos `84Pass@` por tu clave
> [!CAUTION]
> El siguiente codigo lanzalo linea a linea osea uno a uno.
```
mysql -u root -p
CREATE DATABASE radius;
GRANT ALL ON radius.* TO radius@localhost IDENTIFIED BY "84Pass@";
FLUSH PRIVILEGES;
quit;
```
6. Instalacion de apache server ( si hay instalado lighttpd deshabilitarlo `systemctl disable lighttpd` )
> [!CAUTION]
> El siguiente codigo lanzalo linea a linea osea uno a uno.
```
apt -y install apache2
apt -y install php libapache2-mod-php php-{gd,common,mail,mail-mime,mysql,pear,mbstring,xml,curl}
apt -y install freeradius freeradius-mysql freeradius-utils
systemctl enable --now freeradius.service
mysql -u root -p radius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql
ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/
```
7. Instalacion de Daloradius
- Clonamos este repositorio para usar sus carpetas.

```
git clone https://github.com/Fibored/daloradiusred.git daloradiusred
```

- Movemos la carpeta daloradius a html del servidor
```
\mv /root/daloradiusred/server/daloradius /var/www/html/
\mv /root/daloradiusred/server/print /var/www/html/
```

- Remplazamos unos archivos por algunos editados, puedes hacer una comparacion de cambios con algun software en linea, en el mismo archivo hay una leyenda donde se cambio que dice: Wirisp cambiar aqui.

```
\mv /root/daloradiusred/root/dalomv/radiusd.conf /etc/freeradius/3.0/radiusd.conf
\mv /root/daloradiusred/root/dalomv/exten-radius_server_info.php /var/www/html/daloradius/library/exten-radius_server_info.php
\mv /root/daloradiusred/root/dalomv/default /etc/freeradius/3.0/sites-enabled/default
\mv /root/daloradiusred/root/dalomv/sqlcounter /etc/freeradius/3.0/mods-available/sqlcounter
\mv /root/daloradiusred/root/dalomv/access_period.conf /etc/freeradius/3.0/mods-config/sql/counter/mysql/access_period.conf
\mv /root/daloradiusred/root/dalomv/quotalimit.conf /etc/freeradius/3.0/mods-config/sql/counter/mysql/quotalimit.conf
\mv /root/daloradiusred/root/dalomv/eap /etc/freeradius/3.0/mods-available/eap
\mv /root/daloradiusred/root/dalomv/queries.conf /etc/freeradius/3.0/mods-config/sql/main/mysql/queries.conf
\mv /root/daloradiusred/root/dalomv/radutmp /etc/freeradius/3.0/mods-enabled/radutmp
\mv /root/daloradiusred/root/dalomv/sql /etc/freeradius/3.0/mods-available/sql
\mv /root/daloradiusred/root/dalomv/daloradius.conf.php /var/www/html/daloradius/library/daloradius.conf.php
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

> [!CAUTION]
> Agregamos el password a nuestra base de datos, siendo `84Pass@` la default y `84Elij@` o que haz elegido.

```
sed -i 's/84Uniq@/84Elij@/g' "/root/daloradiusred/root/dalomv/base.sql"
```
- Restauramos base de datos

```
mysql -p -u root radius < /root/daloradiusred/root/dalomv/base.sql
```


- Darle permisos a carpetas log
```
chmod 777  /var/log/syslog
chmod 777 /var/log/freeradius
#chmod 755 /var/log/radius/
#chmod 644 /var/log/radius/radius.log
touch /var/log/messages
chmod 644 /var/log/messages
#chmod 644 /var/log/dmesg
touch /tmp/daloradius.log
```


- Modificamos los passwords de la base de datos en los scripts la cual por default es 84Pass@.
podemos utilizar el siguiente comando para reemplazarlo por el password que elegistes ejemplo 84Elij@ .

- Primero buscamos lo que queremos cambiar, anotamos los archivos donde se encuentra
```
grep -rl "84Pass@" /var
grep -rl "84Pass@" /etc
```

- Ahora cambiamos ese password `84Pass@` por la que nosotros decidamos `84Elij@` por ejemplo, en su caso coloca tu password elegido.
> [!CAUTION]
> El siguiente codigo copia linea a linea ya que tienes que cambiar datos.

```
passwd="84Elij@"
sed -i "s/84Pass@/$passwd/g" "/var/www/html/daloradius/library/daloradius.conf.php"
sed -i "s/84Pass@/$passwd/g" "/var/www/html/print/index.php"
sed -i "s/84Pass@/$passwd/g" "/var/www/html/print/SimpleAuth.php"
sed -i "s/84Pass@/$passwd/g" "/etc/freeradius/3.0/mods-available/sql"

```

- Reiniciar sistema e ingresar

```
reboot
```


> [!CAUTION]
> El siguiente codigo lanzalo linea a linea osea uno a uno para checar servicios.
```
systemctl status apache2
systemctl status freeradius
```

- Ingresar a daloradius por la direccion `http://IP/daloradius` con usuario `administrator` y clave elegida  `84Elij@` puedes cambiar el usuario `Rivera` de inicio con.
```
sed -i 's/Rivera/Myusuario/g' "/var/www/html/daloradius/login.php"
```
_Si hay error de puertos Es necesario que se abran los puertos en el vps de administracion 1812,1813,3306,6813,80,8080,443_

8. Agregando scripts y crontab para mantenimiento.
```
crontab -e
```

Agregamos las siguientes lineas
```
#backup diario de la base de datos daloradius
0 10 * * * sudo bash /root/scripts/backupdbradius.sh
#limpieza de fichas usadas vigencia de 11 dias elegida en el script
0 20 * * * sudo bash /root/scripts/limpiaCorridos.sh
#limpieza de fichas usadas vigencia de 11 dias elegida en el script
0 22 * * * sudo bash /root/scripts/limpiaPausados.sh
```

Guardamos el archivo, y ahora movemos la carpeta de los scripts a /root
```
\mv /root/daloradiusred/root/scripts /root/scripts/
\mv /root/daloradiusred/root/backupdb /root/backupdb/
\mv /root/daloradiusred/root/docker /root/docker/
```

- Para cambiarles el password a los scripts, recuerda que en vez de `84Elij@` necesitamos colocar el que elegimos.
> [!CAUTION]
> En el siguiente codigo coloca tu password en lugar de la variable 84Elij@.

```
passwd="84Elij@"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/rmanual/limpiamanual.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/limpiaCorridos.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/limpia7dCorridos.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/cleaner/rmcreationdate.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/cleaner/eliminabatch.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/cleaner/rmuserinfofirst.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/cleaner/removegroupname.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/cleaner/eliminadb.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/listar/crearlista.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/backupdbradius.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/cleanradpostauth.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/limpiaPausados.sh"
sed -i "s/84Pass@/$passwd/g" "/root/scripts/radacct_trim.sh"
```


Encontraremos tambien las configuracion para desplegar contenedores de unifi, omada, wireguard con pihole unbound.

### Acceso a daloradius

```
Iniciar sesion
WEB: IP/daloradius
Usuario: administrator
Pass: 84Elij@
```
Despues de acceder, nos dirijimos a `http://IP/daloradius/config-operators.php` para cambiar el password y usuarios.

### Instalacion docker y docker compose
Instalamos docker y docer compose en debian, necesarios para instalar en contenedores : unifi,omada,wireguard

> [!CAUTION]
> El siguiente codigo lanzalo linea a linea osea uno a uno

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

- Agrega el repositorio de un solo golpe todo
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
- Actualizamos repositorios
```
sudo apt-get update
```
> [!CAUTION]
> El siguiente codigo lanzalo linea a linea osea uno a uno para instalar paquetes

```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose -v
docker -v
```

### Istalando omada
- Entramos a la carpeta y editamos el archivo de configuracion
```
cd /root/docker/omada/
cat docker-compose.yml

```

Ejecutamos el contenedor, teniendo ya instalado docker y docker compose.
```
docker-compose up -d
```
Accedemos con
```
Acceso: https://IP:8043/
```
### Instalando unifi
- Entramos a la carpeta y editamos el archivo de configuracion
```
cd /root/docker/unifi/
cat docker-compose.yml

```

Ejecutamos el contenedor, teniendo ya instalado docker y docker compose.
```
docker-compose up -d
```
Accedemos con
```
Acceso: https://IP:8443/
```
### Instalacion Wireguard pihole unbound
1. Instalamos pihole
```
curl -sSL https://install.pi-hole.net | bash
```
2. Cambiamos el password
```
pihole -a -p
```
3. Desactivamos lighttpd para no hacer conflicto con otro
```
sudo systemctl disable lighttpd
```
4. Instalamos pivpn
```
curl -L https://install.pivpn.io | bash
```
5. Instalamos unbound
```
sudo apt install unbound
```
6. lanzamos la siguiente linea
```
wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints
```
7. Editamos el archivo siguiente
```
sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
```
7.1. Le agregamos lo siguiente
```
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # Suggested by the unbound man page to reduce fragmentation reassembly problems
    edns-buffer-size: 1472

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
```
7.1.2. Reiniciamos el servicio
```
sudo service unbound restart
```

8. Creamos un usuario
```
pivpn -a
```
8.1 Lo convertimos a codigo qr para usarlo en el celular
```
pivpn -qr
```
8.1 Con esto puedes ver la ip de tu dns
```
ip a show dev wg0
```
9. Editamos el archivo setupVars.conf
```
nano /etc/pihole/setupVars.conf
```
9.1 cambia los datos de estas lineas
```
PIHOLE_INTERFACE=wg0
LIGHTTPD_ENABLED=false
PIHOLE_DNS_1=127.0.0.1#5335
PIHOLE_DNS_2=127.0.0.1#5335
```

10. Reiniciamos
```
reboot
```
10.1 Checar si hay algun conflicto de puerto
```
netstat -ltnp | grep :80

### Respaldo carpeta html completa
```
cd /var/www
tar -zcvf html.tar.gz html
Descomprimir con
cd /var/www/html
tar -xf html.tar.gz
```

