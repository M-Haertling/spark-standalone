# Spark Standalone Cluster
This is an experimental implementation of a spark standalone cluster.

To promote an understanding of the Spark installation process, a Spark enabled image is built manually. This requires the appropriate binaries to be available locally. This keeps image compilation fast if you tweak the image during experimentation as opposed to downloading Spark during image creation. The spark binaries can be downloaded from: https://www.apache.org/dyn/closer.lua/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz


## The Cluster
Every Spark cluster needs a resource controller and one or more workers. Here, we use the Spark standalone resource server to managed our cluster. The workers and leader use the same image because the singular Spark installation includes all the nessesary binaries for both services. Both openjdk11 and python3 are installed so pyspark will be supported by the cluster. Bash, procps (for ps), and coreutils (for nohup) are installed because they are required by the cluster start scripts included in the Spark install. The baseline image is *alpine* to keep things relatively light.

**Building the Spark Image**
```
docker build --file docker/pyspark.Dockerfile -t pyspark docker
```

The image can be explored by spinning up a container instance and opening a shell console. Alpine doesn't have bash installed by default, but its basic predacessor should be sufficient.
```
docker run -it pyspark bash
java --version
python3 --version
pip3 --version
```

Notice, there is no *ENTRYPOINT* definied in the Dockerfile because we want to control which function is kicked off dynamically. Two helper files are created: leader and worker. This makes it relatively simple to spin up a leader and workers.
```
docker run --name spark-leader -p 8080 -p 5858:5858 -d pyspark bash ./leader
docker run --name spark-worker1 -d pyspark bash ./worker
```

**Docker Compose**
Alternately, all needed services can be spun up using Docker Compose.
```
docker compose --project-name spark-standalone --file docker/docker-compose.yml up
```

The compose file defines the following services:
| Service | Description | Webapp |
| - | - | - |
| spark-leader | the resource manager for Spark processing | http://localhost:5810/ |
| spark-worker1 | Spark worker 1 | http://localhost:5811/ |
| spark-worker2 | Spark worker 2 |  |
| database | a mysql instance |  |
| adminer | a simple mysql webapp for managing the environment | http://localhost:5811/ |
| pyspark-client | a pre-loaded virtual environment to kick off spark jobs | |

The mysql credentials are:
* Server: database
* Username: admin
* Password: example

You can validate that the spark cluster and mysql server are running by checking their respective web UIs.

## The Virtual Environment
The pyspark-client container has java and python installed, plus the handfull of python libraries needed for testing. Additionally, the project directory has been mapped to /share. This makes it easy to edit the python scripts locally and run then on the docker network. Any attempt to kick off a job via the exposed spark master port (spark-leader:5858) will fail because the client is expected to open a port and receive communications initiated from the spark cluster. Switching the container network to use the host network does not work for container to host traffic on Windows and Mac due to the vm that Docker actually runs on. 

Open up a terminal and connect to the container:
```
docker exec -it pyspark-client bash
```

The project directory is mounted under share:
```
cd /share/src
```
### Generating Dummy Data
The mysql database is a fresh insall. The datagen.py script creates a database with some data to experiment with.
```
python3 src/datagen.py
```

The dummy data should be visible through the mysql adminer interface. There should be a new database created called dummydata, in which there is a dummy_data table containing randomly generated data.

### Submitting a Spark App

MySQL JDBC Connector
Download the mysql JDBC connector jar and drop it into the src directory. This will be shipped to the Spark cluster as part of the pyspark process.
https://mvnrepository.com/artifact/com.mysql/mysql-connector-j/8.0.33

Once the connector is in place, run some tests.
```
python3 spark.py
```