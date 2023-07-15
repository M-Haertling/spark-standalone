# Spark Standalone Cluster
This is an experimental implementation of a spark standalone cluster. The spark binaries can be downloaded from: https://www.apache.org/dyn/closer.lua/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz

Dockerfile
```
docker build docker -t spark
docker run -it spark ./bin/bash
docker run --name spark -itd spark
```

Manual Container Setup
```
docker run --name spark-leader -p 8080 -p 5858:5858 -d spark ./bin/bash ./leader
docker run --name spark-worker1 -d spark ./bin/bash ./worker
docker run --name spark-worker2 -d spark ./bin/bash ./worker
```

Docker Compose Setup
```
docker compose build
docker compuse up
```


```
pip install -r datagen-requirements.txt
```