#!/usr/bin/env bash
${SPARK_HOME}/sbin/start-worker.sh --host ${SPARK_WORKER_URL} --port ${SPARK_WORKER_PORT} --webui-port ${SPARK_WORKER_WEB_PORT} ${SPARK_LEADER_URL}:${SPARK_LEADER_PORT}
tail -F /spark/spark-*/logs/*.out