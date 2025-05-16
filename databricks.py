databricks

from pyspark.sql import SparkSession
from pyspark.sql import Row

# Create a SparkSession (if not already created)
spark = SparkSession.builder.appName("Salary Data").getOrCreate()

# Define the data as a list of Row objects
data = [
    Row(Id=1, Month=1, Salary=20),
    Row(Id=2, Month=1, Salary=20),
    Row(Id=1, Month=2, Salary=30),
    Row(Id=2, Month=2, Salary=30),
    Row(Id=3, Month=2, Salary=40),
    Row(Id=1, Month=3, Salary=40),
    Row(Id=3, Month=3, Salary=60),
    Row(Id=1, Month=4, Salary=60),
    Row(Id=3, Month=4, Salary=70),
]

# Create a DataFrame from the list of rows
df = spark.createDataFrame(data)

# Show the DataFrame to verify the result
df.show()


SparkSession: This is the entry point to using Spark in Databricks. It allows you to use DataFrame APIs.

Row: The Row is used to define a structure for the data. It's similar to a row in a table.

createDataFrame: This function is used to convert the list of rows into a DataFrame.





Data sources for spark - JSON, parquet, txt


-    forming dataframes 

   >>>  df = spark.read.json("customer.json")
     >>>   df3 = spark.read.load("users.parquet")
>>> df4 = spark.read.text("people.txt") 


- select statement 

df.select()
































    
