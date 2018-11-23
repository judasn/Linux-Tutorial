#!/bin/bash


backupDatetime=$1

if [ "$backupDatetime" = "" ];
then
    echo -e "\033[0;31m 请输入备份日期 \033[0m"
    exit 1
fi

echo "备份日期 = $backupDatetime"

/usr/bin/mysqldump -u root --password=adg123adg456adg wordpress > /opt/wordpress-"$backupDatetime".sql



