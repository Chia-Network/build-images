#!/bin/sh

check_env_var() {
    var_name=$1
    eval var_value="\$$var_name"

    if [ -z "$var_value" ]; then
        echo "Error: Environment variable $var_name is not set or is empty."
        exit 1
    fi
}

# Check required environment variables
check_env_var "SITENAME"
check_env_var "WEBROOT_PATH"
check_env_var "DB_HOST"
check_env_var "DB_NAME"
check_env_var "DB_USER"
check_env_var "DB_PASS"
check_env_var "BUCKET_NAME"

DATE=$(date +%d%m%y%H%M)

# export database
mysqldump --single-transaction -h "$DB_HOST" -u "$DB_USER" "-p${DB_PASS}" "$DB_NAME" | gzip > "/tmp/site-backup/${SITENAME}_${DATE}.sql.gz"

# export files
tar cvzf "/tmp/site-backup/${SITENAME}_${DATE}.tar.gz" -C "$WEBROOT_PATH"

# sync to amazon
aws s3 cp "/tmp/site-backup/${SITENAME}_${DATE}.sql.gz" "s3://${BUCKET_NAME}/"
aws s3 cp "/tmp/site-backup/${SITENAME}_${DATE}.tar.gz" "s3://${BUCKET_NAME}/"
