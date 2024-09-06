#!/bin/bash

# Dump the PostgreSQL database
PGPASSWORD="${password}" pg_dump -h "${host}" -p "${port}" -U "${username}" -f temp.sql "${database_name}"

# Get the current time
current_time="$(date "+%Y-%m-%d_%H-%M-%S")"
file_name="${database_name}_${current_time}"

# Encrypt the SQL file with PGP
gpg --output "${file_name}.sql.gpg" --encrypt --recipient "${pgp_recipient}" temp.sql

# Remove the original SQL file
rm temp.sql

# Dropbox Uploader configuration
echo "CONFIGFILE_VERSION=2.0" > ~/.dropbox_uploader
echo "OAUTH_APP_KEY=${dropbox_app_key}" >> ~/.dropbox_uploader
echo "OAUTH_APP_SECRET=${dropbox_app_secret}" >> ~/.dropbox_uploader
echo "OAUTH_REFRESH_TOKEN=${dropbox_refresh_token}" >> ~/.dropbox_uploader

# Download Dropbox Uploader script
curl -s "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
chmod +x dropbox_uploader.sh

# Upload the file to Dropbox
./dropbox_uploader.sh upload "${file_name}.sql.gpg" "$(date "+%Y-%m-%d").zip"

# Delete old backup from Dropbox
./dropbox_uploader.sh delete "$(date +"%Y-%m-%d" --date="7 days ago").zip"

# Clean up local files
rm "${file_name}".*
