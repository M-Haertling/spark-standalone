import mysql.connector
from faker import Faker
fake = Faker()
import random

def createDatabase(cur: mysql.connector.abstracts.MySQLConnectionAbstract.cursor):
    try:
        print("Creating dummydata database...")
        out = cur.execute("CREATE DATABASE dummydata")
        print("Database created successfully.")
    except:
        print("Database already exists.")
        
def createTable(cur: mysql.connector.abstracts.MySQLConnectionAbstract.cursor):
    try:
        print("Creating table...")
        createTableQuery = """
            CREATE TABLE dummy_data(
                id INT NOT NULL AUTO_INCREMENT,
                name VARCHAR(200), 
                address VARCHAR(200), 
                salary DECIMAL,
                netWorth DECIMAL,
                happiness INT,
                PRIMARY KEY (id)
            )
        """
        cur.execute("use dummydata")
        out = cur.execute(createTableQuery)
        print(f"Database table created successfully: {out}")
    except Exception as ex:
        print(f"Database table already exists: {ex}")

def generateRecord() -> (str, str, float, float, int):
    return (fake.name(), fake.address(), random.random()*200000, random.random()*1000000-100000, random.randrange(-100,100))
    
def insertData(cur: mysql.connector.abstracts.MySQLConnectionAbstract.cursor, numRows: int, commitBatchSize: int):
    # Prepared statement wasn't working, but I control the inputs and performance is not a concern
    query = """
        INSERT INTO dummy_data(
            name, address, salary, netWorth, happiness
        ) 
        VALUES(
            '{}', '{}', {:.2f}, {:.2f}, {}
        )
    """
    # %s, %s, %f, %f, %d
    commitCount = 0
    cur.execute("use dummydata")
    for _ in range(numRows):
        cur.execute(query.format(*generateRecord()))
        commitCount += 1
        if commitCount >= commitBatchSize:
            cur.execute("COMMIT")
            commitCount = 0

with mysql.connector.connect(
    host="database",
    user="root",
    password="example"
) as db:
    print(generateRecord())
    with db.cursor() as cur:
        createDatabase(cur)
        createTable(cur)
    with db.cursor() as cur:
        insertData(cur, numRows=10000, commitBatchSize=1000)
    

