#!/usr/bin/env bash
####!/bin/sh
#set -x
#MYSQL DETAILS
SQLUSER="root"
SQLPASS="84Pass@"
DB="radius"
Days="60"
export MYSQL_PWD=$SQLPASS
CMD="mysql -u$SQLUSER --skip-column-names -s -e"
# This is one time step.
echo "- Paso 1 : Checando existencia de la DB: $DB /.."
DBCHK=`mysqlshow --user=$SQLUSER $DB | grep -v Wildcard | grep -o $DB`
if [ "$DBCHK" == "$DB" ]; then
echo " > $DB DB encontrada"
else
echo " > $DB no encontrada ..."
fi
 
# Start Action: copy data from radacct to new db/archive table
NOTULL_COUNT=`$CMD "use $DB; select count(*) from radacct WHERE acctstarttime <= DATE_SUB(CURDATE(), INTERVAL $Days day);"`
echo "- Paso 2 : Eliminando $NOTULL_COUNT entradas de la tabla radacct (Fecha posterior a $Days dias) ..."
$CMD "use $DB; DELETE FROM radacct WHERE acctstarttime <= DATE_SUB(CURDATE(), INTERVAL $Days day);"
echo "Finalizada la limpieza de la tabla raddact"
