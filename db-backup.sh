#!/bin/bash

pg_dump "postgresql://${username}:${password}@${host}:${port}/${database_name}" > temp.sq
current_time="$(date "+%Y-%m-%d_%H-%M-%S")"
file_name="${database_name}_${current_time}"
mv temp.sql "${file_name}.sql"
zip -e -P "${zip_password}" "${file_name}.zip" "${file_name}.sql" > /dev/null
echo "CONFIGFILE_VERSION=2.0" > ~/.dropbox_uploader
echo "OAUTH_APP_KEY=${dropbox_app_key}" >> ~/.dropbox_uploader
echo "OAUTH_APP_SECRET=${dropbox_app_secret}" >> ~/.dropbox_uploader
echo "OAUTH_REFRESH_TOKEN=${dropbox_refresh_token}" >> ~/.dropbox_uploader
curl -s "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
chmod +x dropbox_uploader.sh
./dropbox_uploader.sh upload "${file_name}.zip" "$(date "+%Y-%m-%d").zip"
./dropbox_uploader.sh delete "$(date +"%Y-%m-%d" --date="7 days ago").zip"
rm "${file_name}".*
