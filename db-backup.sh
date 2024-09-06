#!/bin/bash

# Dump the PostgreSQL database
PGPASSWORD="${password}" pg_dump -h "${host}" -p "${port}" -U "${username}" -f dump.sql "${database_name}"

# Encrypt the SQL file with PGP
gpg --trust-model always --encrypt --recipient "${pgp_recipient}" dump.sql

# Dropbox Uploader configuration
echo "CONFIGFILE_VERSION=2.0" > ~/.dropbox_uploader
echo "OAUTH_APP_KEY=${dropbox_app_key}" >> ~/.dropbox_uploader
echo "OAUTH_APP_SECRET=${dropbox_app_secret}" >> ~/.dropbox_uploader
echo "OAUTH_REFRESH_TOKEN=${dropbox_refresh_token}" >> ~/.dropbox_uploader

# Download Dropbox Uploader script
curl -s "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
chmod +x dropbox_uploader.sh

# Upload the file to Dropbox
./dropbox_uploader.sh upload dump.sql.gpg "$(date "+%Y-%m-%d").sql.gpg"

# Delete old backup from Dropbox
./dropbox_uploader.sh delete "$(date +"%Y-%m-%d" --date="7 days ago").sql.gpg"

# Clean up local files
rm dump.sql "$(date "+%Y-%m-%d").sql.gpg"

