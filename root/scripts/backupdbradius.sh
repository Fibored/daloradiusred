#! /bin/bash
username=root
password=84Pass@
database=radius
now="$(date +'%d_%m_%Y_%H_%M_%S')"
filename="base_$now".sql
backupfolder="/root/backupdb"
fullpathbackupfile="$backupfolder/$filename"
logfile="$backupfolder/"base_log_"$(date +'%Y_%m')".txt
echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --user=$username --password=$password $database > $fullpathbackupfile
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

echo "remove backup 3 days old" >> "$logfile"
# Delete files older than 3 days
find $backupfolder/* -mtime +3 -exec rm {} \;
echo "complete removing" >> "$logfile"
exit 0
#sudo chmod +x backupdbradius.sh
#sudo ./backupdbradius.sh
