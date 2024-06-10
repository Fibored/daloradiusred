#!/bin/sh
#set -x
# Este script elimina fichas de hace 10 dias de uso, y tambien limpia las bases de datos de hace 30 dias.
# Cambiar el password de tu DB
SQLPASS="84Pass@"
export MYSQL_PWD=$SQLPASS
> /tmp/expired.users.txt
> /root/scripts/listar/lista.txt
# extrae listado de usuarios del grupo en el sistema.
mysql -uroot -e "use radius; SELECT username FROM radusergroup WHERE groupname = '30dCorridos'" |sort > /tmp/expired.users.txt
# Extrae listado de usuarios en el batch o lote.
#mysql -uroot -e "use radius; SELECT username FROM fichas WHERE batch_name = '2401237dOF'" |sort > /tmp/expired.users.txt
# Extrae usuarios con userinfo.firstname
#mysql -uroot -e "use radius; SELECT username FROM userinfo WHERE userinfo.firstname like '2401212B%'" |sort > /tmp/expired.users.txt
#Copia usuarios a /root/scripts/listar/lista.txt
cp /tmp/expired.users.txt /root/scripts/listar/lista.txt
echo "Base de datos limpiada correctamente"
cat /root/scripts/listar/lista.txt
