#!/bin/bash
#
# Steve's database backup script
#
# Get date and time for backup file
date=$(date +%y%m%d.%H%M) 
now=$(date +%H:%M:%S)
echo "Starting..." 
ROOTDIR="/mnt/new_db_backup/mdb01" 
YEAR=`date +%Y` 
MONTH=`date +%m` 
DAY=`date +%d` 
HOUR=`date +%H` 
SERVER="localhost" 
BLACKLIST="information_schema performance_schema" 
if [ ! -d "$ROOTDIR/$YEAR/$MONTH/$DAY/$HOUR" ]; then
  mkdir -p "$ROOTDIR/$YEAR/$MONTH/$DAY/$HOUR" 
  fi 
echo "running dump" 
dblist=`mysql -u root -pJm09rE23Zz -h $SERVER -e "show databases" | sed -n '2,$ p'` 

for db in $dblist; do
    echo "Backuping $db"
    isBl=`echo $BLACKLIST |grep $db`
    if [ $? == 1 ]; then
        mysqldump --single-transaction -u root -pJm09rE23Zz -h $SERVER $db | gzip --best > "$ROOTDIR/$YEAR/$MONTH/$DAY/$HOUR/$db.sql.gz"
        echo "Backup $db ends with return code $?"
    else
        echo "Database $db is on blacklist, skip"
    fi 
done 
echo "dump completed"
# remove older backups 
# find $backup_path/* -mtime +$days -exec ls {} \;
