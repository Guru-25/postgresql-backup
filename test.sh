#!/bin/bash

echo "CONFIGFILE_VERSION=2.0" > ~/.dropbox_uploader
echo "OAUTH_APP_KEY=${OAUTH_APP_KEY}" >> ~/.dropbox_uploader
echo "OAUTH_APP_SECRET=${OAUTH_APP_SECRET}" >> ~/.dropbox_uploader
echo "OAUTH_REFRESH_TOKEN=${OAUTH_REFRESH_TOKEN}" >> ~/.dropbox_uploader
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
chmod +x dropbox_uploader.sh
mariadb-dump --no-tablespaces -h "${host}" -P ${port} -u "${db_user}" -p"${db_pass}" "${db_name}" > temp.sql
file_name="$(date "+%Y-%m-%d")"
old_file_name="$(date +"%Y-%m-%d" --date="7 days ago")"
mv temp.sql "${file_name}.sql"
zip -e -P "${zip_pass}" "${file_name}.zip" "${file_name}.sql"
./dropbox_uploader.sh upload "${file_name}.zip" "${file_name}.zip"
./dropbox_uploader.sh delete "${old_file_name}.zip"
rm "${file_name}".*
