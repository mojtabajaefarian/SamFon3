#!/bin/bash

# Database Backup Configuration
BACKUP_DIR="/var/backups/mysql"
MYSQL_USER="backup_user"
MYSQL_PASSWORD="secure_backup_password"
DATABASE="samfon_db"

# Create Backup Directories
mkdir -p $BACKUP_DIR/daily
mkdir -p $BACKUP_DIR/weekly

# Generate Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Daily Backup
mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD \
    --single-transaction \
    --routines \
    --triggers \
    --compress \
    $DATABASE > $BACKUP_DIR/daily/backup_$TIMESTAMP.sql.gz

# Retention Policy: Remove backups older than 7 days
find $BACKUP_DIR/daily -type f -mtime +7 -delete

# Weekly Full Backup (on Sunday)
if [ $(date +%u) -eq 7 ]; then
    cp $BACKUP_DIR/daily/backup_$TIMESTAMP.sql.gz \
       $BACKUP_DIR/weekly/full_backup_$TIMESTAMP.sql.gz
fi

# Log Backup Details
echo "Backup completed: $TIMESTAMP" >> /var/log/mysql_backups.log

# Optional: Send email notification
if [ $? -eq 0 ]; then
    echo "Database backup successful" | \
    mail -s "MySQL Backup Status" admin@example.com
fi