#!/bin/bash

host=""
port=
db_user=""
db_pass=""
db_name=""
zip_pass=""
tg_bot_token=""
tg_chat_id=""

current_date=$(date "+%Y-%m-%d")
file_name="${db_name}-${current_date}"
mariadb-dump --no-tablespaces -h "${host}" -P ${port} -u "${db_user}" -p"${db_pass}" "${db_name}" > "${file_name}.sql"
zip -e -P "${zip_pass}" "${file_name}.zip" "${file_name}.sql" > /dev/null
curl -s -F chat_id="${tg_chat_id}" -F document=@"${file_name}.zip" "https://api.telegram.org/bot${tg_bot_token}/sendDocument" > /dev/null
rm "${file_name}".*