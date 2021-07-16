#!/usr/bin/env bash
#
# Steve's database backup script
# https://github.com/stevehillin/Mysql-DB-Backup

# Get environment variables via setenv.sh
source setenv.sh

# Get date and time for backup file path
date=$(date +%y%m%d.%H%M)

# Begin
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
HOUR=`date +%H`
if [ ! -d "$ROOT_DIR/$YEAR/$MONTH/$DAY/$HOUR" ]; then
    echo "Creating directory structure $ROOT_DIR/$YEAR/$MONTH/$DAY/$HOUR"
    mkdir -p "$ROOT_DIR/$YEAR/$MONTH/$DAY/$HOUR"
    fi

echo "Getting database list from MySQL"
dblist=`mysql -u$MYSQL_USER -p$MYSQL_PASS -h $MYSQL_SERVER -e "show databases" | sed -n '2,$ p'`

for db in $dblist; do
    echo "Performing backup of $db"
    isExcluded=`echo $EXCLUDE_LIST |grep $db`
    if [ $? == 1 ]; then
        mysqldump --single-transaction -u$MYSQL_USER -p$MYSQL_PASS -h $MYSQL_SERVER $db | gzip --best > "$ROOT_DIR/$YEAR/$MONTH/$DAY/$HOUR/$db.sql.gz"
        echo "Backup of $db ended with return code $?"
    else
        echo "Database $db is on excluded list, skipping"
    fi
done
echo "Mysql backups complete"
