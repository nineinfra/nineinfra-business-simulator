#!/bin/bash

WORK_DIR=/opt/nineinfra
BIN_DIR=${WORK_DIR}/bin
CONF_DIR=${WORK_DIR}/conf
LOG_DIR=${WORK_DIR}/logs
LOG_APP=${BIN_DIR}/log/mock-log.jar
PROFILE=${CONF_DIR}/application.yml
LOG_CONF_FILE=${CONF_DIR}/logback.xml

if [ -n "$1" ]; then
    MOCK_DATE="$1"
else
    MOCK_DATE=$(date +%F)
fi

LOG_FILE="simulator-app-log-${MOCK_DATE}.log"

echo "------------------------mock-log:${MOCK_DATE}--------------------------------------"
sed -i "s#mock.date.*#mock.date: \"${MOCK_DATE}\"#g" "${PROFILE}"
sed -i "s#<property name=\"MOCK_DATE\" value=.*#<property name=\"MOCK_DATE\" value=\"${MOCK_DATE}\" />#g" "${LOG_CONF_FILE}"
nohup java -jar "${LOG_APP}" --spring.config.location="${PROFILE}"  >> "${LOG_DIR}/${LOG_FILE}" 2>&1

exit 0
