#!/bin/bash

WORK_DIR=/opt/nineinfra
BIN_DIR=${WORK_DIR}/bin
CONF_DIR=${WORK_DIR}/conf
LOG_DIR=${WORK_DIR}/logs
DB_BIN_DIR=${BIN_DIR}/db
DB_APP=${DB_BIN_DIR}/mock-db.jar
PROFILE=${CONF_DIR}/application.properties
FIRSTDAY_PROFILE=${CONF_DIR}/firstday.application.properties
MYSQL_DB_NAME=nineinfra
MYSQL_USER=nineinfra
MYSQL_PASSWORD=nineinfra
MYSQL_HOST=nineinfra-mysql
TABLE_SQL=${DB_BIN_DIR}/table.sql
DATA_SQL=${DB_BIN_DIR}/data.sql

if [ -n "$1" ]; then
    MOCK_DATE="$1"
else 
    MOCK_DATE=$(date +%F)
fi

LOG_FILE="simulator-app-db-${MOCK_DATE}.log"

export MYSQL_PWD=${MYSQL_PASSWORD}
EXIST_DB=$(mysql -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$MYSQL_DB_NAME'" | grep $MYSQL_DB_NAME)
if [ -z "$EXIST_DB" ]; then
    echo "------------------------mock-db:create database------------------------------------"
    mysql -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -e "CREATE DATABASE ${MYSQL_DB_NAME}"
    echo "------------------------mock-db:create tables--------------------------------------"
    mysql -h"${MYSQL_HOST}" -u"${MYSQL_USER}" ${MYSQL_DB_NAME} < ${TABLE_SQL}
    echo "------------------------mock-db:load data------------------------------------------"
    mysql -h"${MYSQL_HOST}" -u"${MYSQL_USER}" ${MYSQL_DB_NAME} < ${DATA_SQL}
    echo "------------------------mock-db:${MOCK_DATE}---------------------------------------"
    sed -i "s#mock.date =.*#mock.date = ${MOCK_DATE}#g" "${FIRSTDAY_PROFILE}"
    nohup java -jar "${DB_APP}" --spring.config.location="${FIRSTDAY_PROFILE}" >> "${LOG_DIR}/${LOG_FILE}" 2>&1
else
    echo "------------------------mock-db:${MOCK_DATE}---------------------------------------"
    sed -i "s#mock.date =.*#mock.date = ${MOCK_DATE}#g" "${PROFILE}"
    nohup java -jar "${DB_APP}" --spring.config.location="${PROFILE}" >> "${LOG_DIR}/${LOG_FILE}" 2>&1
fi

exit 0
