# look into dependency management
# look into spark history server
# spark streaming

from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("spark://spark-leader:5800") \
    .appName("TestSpark") \
    .config("spark.jars", "mysql-connector-j-8.0.33.jar") \
    .getOrCreate()
    
spark.sparkContext.setLogLevel("INFO")
    
# Create RDD from parallelize    
# dataList = [("Java", 20000), ("Python", 100000), ("Scala", 3000)]
# rdd=spark.sparkContext.parallelize(dataList)

# Create RDD from external Data source
# rdd2 = spark.sparkContext.textFile("/path/test.txt")

# Transformations are lazy
# flatMap(), map(), reduceByKey(), filter(), sortByKey()

# Actions return the values to a driver node -> does not return an RDD
# count(), collect(), first(), max(), reduce()

# df = spark.createDataFrame(dataList).createOrReplaceTempView("TEST_VIEW")
# df = spark.sql("SELECT * FROM TEST_VIEW")

    #.option("partitionColumn", "test") \
    #.option("lowerBound", "test") \
    #.option("upperBound", "test") \
df = spark.read \
    .option("numPartitions", 4) \
    .option("partitionColumn", "happiness") \
    .option("lowerBound", 0) \
    .option("upperBound", 100) \
    .jdbc(
        url="jdbc:mysql://database:3306/dummydata",
        table="dummy_data",
        properties= {
            "driver":"com.mysql.cj.jdbc.Driver",
            "user": "root",
            "password": "example"
        }
    )
df.explain()
df.createOrReplaceTempView("people")
    
df = spark.sql("SELECT name, salary, happiness FROM people").show(n=100)