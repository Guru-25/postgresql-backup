#!/bin/bash

# Get the date 7 days ago. Used to delete the redundant backup file.
old_date=$(date +"%Y-%m-%d" --date="7 days ago")

git clone https://github.com/andreafabrizi/Dropbox-Uploader
mv Dropbox-Uploader/dropbox_uploader.sh .
chmod +x dropbox_uploader.sh

mariadb-dump --no-tablespaces -h "${host}" -P ${port} -u "${db_user}" -p"${db_pass}" "${db_name}" > temp.sql
current_time="$(date "+%Y-%m-%d")"
file_name="${current_time}"
mv temp.sql "${file_name}.sql"
zip -e -P "${zip_pass}" "${file_name}.zip" "${file_name}.sql" > /dev/null

echo "Uploading backup tarball to Dropbox..."
./dropbox_uploader.sh upload "${file_name}.zip"

# Delete the old backup
echo "Deleting old Dropbox backup..."
./dropbox_uploader.sh delete $old_date.zip

rm "${file_name}".*

echo "Finished"
