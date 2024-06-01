#!/bin/bash

mariadb-dump --no-tablespaces -h "${host}" -P ${port} -u "${db_user}" -p"${db_pass}" "${db_name}" > temp.sql
current_time="$(date "+%Y-%m-%d_%H-%M-%S")"
file_name="${db_name}_${current_time}"
mv temp.sql "${file_name}.sql"
zip -e -P "${zip_pass}" "${file_name}.zip" "${file_name}.sql" > /dev/null
curl -s -F chat_id="${tg_chat_id}" -F document=@"${file_name}.zip" "https://api.telegram.org/bot${tg_bot_token}/sendDocument" > /dev/null
rm "${file_name}".*
