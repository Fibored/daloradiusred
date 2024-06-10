#!/bin/sh
#set -x
# This script delets users who have expired 2 months ago. and then delete there records from all tables.
# Syed Jahanzaib / June 2019
SQLPASS="84Pass@"
USER="ABC1"
export MYSQL_PWD=$SQLPASS
> /tmp/expired.users.txt

#mysql -uroot -e “use radius; select username from rm_users where expiration BETWEEN ‘2010-01-01’ AND ‘2019-04-30’;” |sort > /tmp/expired.users.txt

# Fetch users who have expired 2 months ago & before, (using expired date), BE CAREFUL WHEN USING THIS
#mysql -uroot -e "use radius; SELECT username FROM radusergroup WHERE groupname = '3HrPausada' OR groupname = 'Wispr3HrPau'" |sort > /tmp/expired.users.txt
mysql -uroot -e "use radius; SELECT username FROM userinfo WHERE username = '$USER'" |sort > /tmp/expired.users.txt
num=0
cat /tmp/expired.users.txt | while read users
do
num=$[$num+1]
USERNAME=`echo $users | awk '{print $1}'`
echo "$USERNAME"
mysql -uroot -e "use radius; DELETE FROM userinfo WHERE username = '$USERNAME';"
mysql -uroot -e "use radius; DELETE FROM radcheck WHERE username = '$USERNAME';"
mysql -uroot -e "use radius; DELETE FROM radacct WHERE username = '$USERNAME';"
mysql -uroot -e "use radius; DELETE FROM radusergroup WHERE username = '$USERNAME';"
mysql -uroot -e "use radius; DELETE FROM userbillinfo WHERE username = '$USERNAME';"
done
#Copia usuarios a root
cp /tmp/expired.users.txt /root/scripts/exp.txt
# Parte 2 para limpiar la base de datos en radpostauth && raddact
mysql -uroot -e "use radius; DELETE FROM radpostauth WHERE authdate <= DATE_SUB(CURDATE(), INTERVAL 30 day);"
mysql -uroot -e "use radius; DELETE FROM radacct WHERE acctstarttime <= DATE_SUB(CURDATE(), INTERVAL 30 day);"
mysql -uroot -e "use radius; DELETE FROM userbillinfo WHERE creationdate <= DATE_SUB(CURDATE(), INTERVAL 30 day);"
echo "Base de datos limpiada correctamente"
