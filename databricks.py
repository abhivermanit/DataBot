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



    - distinct 

    df_new = df.dropDuplicates()


    - add update and remove columns, column operations 

          df = df.withColumnRenamed('telephonenumber' , 'phonenumber')

          ** with select statement the columns are double quotes, with df or functions it it single quote 


          Missing Values :- 

          df = df.drop("col1", "col2") 

          df = df.na.replace(10,20).show()

          df = df.na.fill(50).show()

          df = df.na.drop().show()   #show all rows except the null

        
- group by 

df.groupBy("col1").count() .show()

- order by

df.orderBy(["col1", "col2"],ascending=[0,1]).collect() 


- 






Optimize a PySpark job for large datasets

1. Efficient Data Partitioning: Repartition and Coalesce

2. Use Broadcast Joins for Small Datasets

3. Cache and Persist Data

4. Choose Efficient File Formats (Parquet/Delta)

5. Tune Spark Configuration for Resources


- Proper partitioning ensures that Spark can distribute the work across executors efficiently, minimizing the cost of shuffling and improving parallelism.
    - By repartitioning, you control how many partitions your data is split into across the cluster.
    - Repartitioning is done before wide transformations
    - wide transformations - require shuffling data across multiple nodes - expensive operations
    - wide transformations - groupBy, join, or distinct
    - narrow transformations - map(), filter(), select(), union(), etc. - they operate on a single partition of data 


- In this case, if the data isn't already partitioned by product_id, 
    Spark will shuffle the data across partitions to group all the rows with the same product_id together. 
    This data shuffling makes groupBy() a wide transformation.


- The join() transformation combines rows from two DataFrames based on a common key. It could be a left join, right join, inner join, etc.

- a broadcast join can avoid shuffling when one dataset is small enough to fit in memory.
    one of the tables is small enough to be copied to all the worker nodes. 
    Instead of shuffling large datasets across the network, the small dataset is "broadcast" to every node, avoiding a costly data shuffle.

- large_df: 100 GB table (sales transactions)
  small_df: 1 MB table (country codes)

  from pyspark.sql.functions import broadcast

joined_df = large_df.join(broadcast(small_df), on="country_code")


- In this case, Spark will shuffle the data to ensure that rows with identical values are detected across the entire dataset, making distinct() a wide transformation.


How to do partitioning and repartitioning :-

- 
























    
