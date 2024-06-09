#!/bin/bash

# Get the date 7 days ago. Used to delete the redundant backup file.
old_date=$(date +"%Y-%m-%d" --date="7 days ago")

echo "CONFIGFILE_VERSION=${CONFIGFILE_VERSION}\nOAUTH_APP_KEY=${OAUTH_APP_KEY}\nOAUTH_APP_SECRET=${OAUTH_APP_SECRET}\nOAUTH_REFRESH_TOKEN=${OAUTH_REFRESH_TOKEN}" > ~/.dropbox_uploader
echo "config written"

git clone https://github.com/andreafabrizi/Dropbox-Uploader
echo "git cloned"

mariadb-dump --no-tablespaces -h "${host}" -P ${port} -u "${db_user}" -p"${db_pass}" "${db_name}" > temp.sql
echo "dumped"
current_time="$(date "+%Y-%m-%d")"
file_name="${current_time}"
mv temp.sql "${file_name}.sql"
zip -e -P "${zip_pass}" "${file_name}.zip" "${file_name}.sql" > /dev/null
echo "zipped"

echo "Uploading backup tarball to Dropbox..."
./Dropbox-Uploader/dropbox_uploader.sh upload "${file_name}.zip"
echo "uploaded"

# Delete the old backup
echo "Deleting old Dropbox backup..."
./Dropbox-Uploader/dropbox_uploader.sh delete $old_date.zip
echo "deleted"

rm "${file_name}".*

echo "Finished"
