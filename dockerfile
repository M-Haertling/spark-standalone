FROM adoptopenjdk/openjdk11:latest
#RUN wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1.tgz
#RUN wget https://dlcdn.apache.org/spark/spark-3.4.1/spark-3.4.1-bin-without-hadoop.tgz
ADD spark-3.4.1-bin-hadoop3.tgz /spark
#RUN tar zxvf /spark/spark-3.4.1.tgz
ENV SPARK_HOME="/spark/spark-3.4.1-bin-hadoop3"
ENV SPARK_LEADER_PORT=5858
ENV SPARK_LEADER_WEB_PORT=8080
ENV SPARK_LEADER_URL=spark-leader

RUN echo "\${SPARK_HOME}/sbin/start-master.sh --port \${SPARK_LEADER_PORT} --webui-port \${SPARK_LEADER_WEB_PORT} & sleep infinity" > leader
RUN chmod +x leader


RUN echo "\${SPARK_HOME}/sbin/start-worker.sh spark-leader:\${SPARK_LEADER_PORT} & sleep infinity" > worker
RUN chmod +x worker

#ENTRYPOINT ./sbin/start-slave.sh http://localhost:8080