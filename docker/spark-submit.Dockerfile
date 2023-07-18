FROM spark
ADD ./spark.py /
RUN echo "\${SPARK_HOME}/bin/spark-submit --port \${SPARK_LEADER_PORT} --webui-port \${SPARK_LEADER_WEB_PORT} & sleep infinity" > spark-submit
RUN chmod +x leader