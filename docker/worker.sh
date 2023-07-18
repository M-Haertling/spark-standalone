#!/usr/bin/env bash
${SPARK_HOME}/sbin/start-worker.sh --port ${SPARK_WORKER_PORT} --webui-port ${SPARK_WORKER_WEB_PORT} spark-leader:${SPARK_LEADER_PORT}
tail -f /dev/null