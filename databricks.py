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

import pyspark files 


>>> from pyspark.sql import SparkSession
>>> spark = SparkSession \
 .builder \
 .appName("appname") \
 .config(,) \
 .getOrCreate()

>>> from pyspark.sql import functions as F



Data sources for spark - JSON, parquet, txt


-    forming dataframes 

   >>>  df = spark.read.json("customer.json")
     >>>   df3 = spark.read.load("users.parquet")
>>> df4 = spark.read.text("people.txt") 


- select statement 

df.select()

column name can be entered to view values, [] is used when some operation/function is to be applied to the column/ specific columns, along with df



- filter conditions

>>> df.select(df["age"] > 24).show()

>>> df.select(df["firstname"], df["age"] + 1).show()

>>> df.select("firstname", F.when(df.age > 30, 1).otherwise(0)) 

columns is with df and functions are used with F

>>> df.select("firstname", df.lastname.startswith("Sm")). show()

>>> df.select(df.firstname.substr(1,3).alias("name")).collect()

** In PySpark, substr() is 1-indexed (unlike Python, which is 0-indexed), 
so this starts at the first character. **

    ** .collect retrieves all the rows and collects them together as a list **

>>> df.select(df.age.between(22,24)).show()



    
































    
