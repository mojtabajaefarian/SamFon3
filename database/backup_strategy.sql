-- استراتژی بکاپ گیری
-- این اسکریپت باید در سیستم اجرایی مانند cron تنظیم شود

-- بکاپ روزانه کامل
-- mysqldump -u [username] -p[password] --single-transaction --routines --triggers \
--   samfon_db > /path/to/backups/daily_full_backup_$(date +"%Y%m%d").sql

-- بکاپ اختصاصی برای جداول مهم
-- mysqldump -u [username] -p[password] --single-transaction \
--   samfon_db users products orders > /path/to/backups/critical_data_backup_$(date +"%Y%m%d").sql

-- حذف بکاپ‌های قدیمی
-- find /path/to/backups/ -type f -mtime +7 -delete