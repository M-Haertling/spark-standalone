FROM adoptopenjdk/openjdk11:latest
#RUN wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1.tgz
#RUN wget https://dlcdn.apache.org/spark/spark-3.4.1/spark-3.4.1-bin-without-hadoop.tgz
ADD spark-3.4.1-bin-hadoop3.tgz /spark
#RUN tar zxvf /spark/spark-3.4.1.tgz
ENV SPARK_HOME="/spark/spark-3.4.1-bin-hadoop3"
ENV SPARK_LEADER_PORT=5858
ENV SPARK_LEADER_WEB_PORT=8080
ENV SPARK_LEADER_URL=spark-leader
ENV SPARK_WORKER_PORT=5859
ENV SPARK_WORKER_WEB_PORT=8081
ENV SPARK_WORKER_URL=spark-worker1

ADD leader.sh /
RUN chmod +x leader.sh

ADD worker.sh /
RUN chmod +x worker.sh

#ENTRYPOINT ./sbin/start-slave.sh http://localhost:8080