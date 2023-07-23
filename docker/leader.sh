#!/usr/bin/env bash
${SPARK_HOME}/sbin/start-master.sh --host ${SPARK_LEADER_URL} --port ${SPARK_LEADER_PORT} --webui-port ${SPARK_LEADER_WEB_PORT}
tail -F /spark/spark-*/logs/*.out