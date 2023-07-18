#!/usr/bin/env bash
${SPARK_HOME}/sbin/start-master.sh --port ${SPARK_LEADER_PORT} --webui-port ${SPARK_LEADER_WEB_PORT}
sleep infinity