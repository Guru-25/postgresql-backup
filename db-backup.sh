#!/bin/bash

mariadb-dump --no-tablespaces -h "${host}" -P ${port} -u "${db_user}" -p"${db_pass}" "${db_name}" > temp.sql
file_name="$(date "+%Y-%m-%d")"
old_file_name="$(date +"%Y-%m-%d" --date="7 days ago")"
mv temp.sql "${file_name}.sql"
zip -e -P "${zip_pass}" "${file_name}.zip" "${file_name}.sql" > /dev/null
echo "CONFIGFILE_VERSION=2.0" > ~/.dropbox_uploader
echo "OAUTH_APP_KEY=${dropbox_app_key}" >> ~/.dropbox_uploader
echo "OAUTH_APP_SECRET=${dropbox_app_secret}" >> ~/.dropbox_uploader
echo "OAUTH_REFRESH_TOKEN=${dropbox_refresh_token}" >> ~/.dropbox_uploader
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh > /dev/null
chmod +x dropbox_uploader.sh
./dropbox_uploader.sh upload "${file_name}.zip" "${file_name}.zip"
./dropbox_uploader.sh delete "${old_file_name}.zip"
rm "${file_name}".*
