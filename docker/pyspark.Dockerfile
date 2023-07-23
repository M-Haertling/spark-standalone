FROM alpine

RUN apk update
RUN apk add --update bash python3 openjdk11 curl git unzip py-pip procps coreutils

ADD spark-requirements.txt /
RUN pip3 install -r /spark-requirements.txt
RUN rm /spark-requirements.txt

ADD datagen-requirements.txt /
RUN pip3 install -r /datagen-requirements.txt
RUN rm /datagen-requirements.txt

ADD spark-3.4.1-bin-hadoop3.tgz /spark
ENV SPARK_HOME="/spark/spark-3.4.1-bin-hadoop3" \
    SPARK_LEADER_PORT=5858 \
    SPARK_LEADER_WEB_PORT=8080 \
    SPARK_LEADER_URL=spark-leader \
    SPARK_WORKER_PORT=5859 \
    SPARK_WORKER_WEB_PORT=8081 \
    SPARK_WORKER_URL=spark-worker1 \
    PYSPARK_PYTHON="python3" \
    PYSPARK_DRIVER_PYTHON="python3"

ADD leader.sh /
RUN chmod +x leader.sh

ADD worker.sh /
RUN chmod +x worker.sh