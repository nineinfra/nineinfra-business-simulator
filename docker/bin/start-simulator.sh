#!/bin/bash

WORK_DIR=/opt/nineinfra
BIN_DIR=${WORK_DIR}/bin
DB_SCRIPTS=${BIN_DIR}/db/mock-db.sh
LOG_SCRIPTS=${BIN_DIR}/log/mock-log.sh
START_DATE=$(date +%F)
MAX_DAYS=5
DAYS=0

if [ -n "$1" ]; then
    START_DATE="$1"
fi

if [ -n "$2" ]; then
    MAX_DAYS="$2"
fi

current_date=$(date -d "$START_DATE" +"%Y-%m-%d")

while [ "${DAYS}" -lt "${MAX_DAYS}" ]
do
    DAYS=$((DAYS + 1))
    "${DB_SCRIPTS}" "${current_date}"
    "${LOG_SCRIPTS}"  "${current_date}"
    current_date=$(date -d "$current_date + 1 day" +"%Y-%m-%d")
    sleep 5
done

exit 0
