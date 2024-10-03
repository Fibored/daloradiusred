#!/bin/sh
#set -x
# This script delets users who have expired 2 months ago. and then delete there records from all tables.
# */5  * * * * sudo bash /root/scripts/NAS-Reboot.sh
SQLPASS="84Pass@"
export MYSQL_PWD=$SQLPASS

mysql -uroot -e "use radius; DELETE FROM radacct WHERE acctterminatecause ='NAS-Reboot';" 


echo "Limpiado los NAS-Reboot"
