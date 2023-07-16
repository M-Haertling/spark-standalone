# Spark Standalone Cluster
This is an experimental implementation of a spark standalone cluster.

To promote an understanding of the Spark installation process, a Spark enabled Java image is built manually. This requires the appropriate binaries to be available locally. This keeps image compilation fast if you tweak the image during experimentation as opposed to downloading Spark during image creation. The spark binaries can be downloaded from: https://www.apache.org/dyn/closer.lua/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz


## The Cluster
Every Spark cluster needs a resource controller and one or more workers. Here, we use the standalone resource server to managed our cluster. Both the workers and leader use the same image because the singular Spark installation includes all the nessesary binaries for both services.

**Building the Spark Image**
```
docker build --file spark.Dockerfile -t spark
```

The image can be oberved by spinning up a container instance and opening a bash console.
```
docker run -it spark ./bin/bash
```

Notice, there is no *ENTRYPOINT* definied in the Dockerfile because we want to control which function is kicked off dynamically. Two helper files are created: leader and worker. This makes it relatively simple to spin up a leader and workers.
```
docker run --name spark-leader -p 8080 -p 5858:5858 -d spark ./bin/bash ./leader
docker run --name spark-worker1 -d spark ./bin/bash ./worker
```

**Docker Compose**
Alternately, all needed services can be spun up using Docker Compose.
```
docker compose up
```

The compose file defines the following services:
| Service | Description | Webapp |
| - | - | - |
| spark-leader | the resource manager for Spark processing | http://localhost:5810/ |
| spark-follower1 | Spark worker 1 |  |
| spark-follower2 | Spark worker 2 |  |
| database | a mysql instance |  |
| adminer | a simple mysql webapp for managing the environment | http://localhost:5811/ |

The mysql credentials are:
* Server: database
* Username: admin
* Password: example

You can validate that the spark cluster and mysql server are running by checking their respective web UIs.

## Generating Dummy Data
Install the nessesary libraries and run the data generate script.
```
pip install -r src/datagen-requirements.txt
python src/datagen.py
```

The dummy data should be visible through the mysql adminer interface. There should be a new database created called dummydata, in which there is a dummy_data table that contains randomly generated data.
## Submitting a Spark App
```
docker build --file spark-submit.Dockerfile --tag spark-submit .
```