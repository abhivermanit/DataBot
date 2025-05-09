In Snowflake:
A Warehouse is NOT a data storage warehouse.
A Warehouse is just a virtual compute engine.

When you do:

USE WAREHOUSE MAPS_DATA_KH_MAINTENANCE_OPS_04_VWH; 

This just tells Snowflake:

"Hey, use this virtual cluster to process my queries, calculations, and transformations."

But the actual data is stored in:

MAPS_DATA_SEMANTIC_DB.KH_MAINTENANCE_OPS



OLAP vs OLTP 

OLAP 

- The data component of OLAP comes from a centralized data store
- An OLAP cube, also known as multidimensional cube or hypercube
- Think of it as:

A multi-dimensional version of an Excel Pivot Table.

                 +---------------------+
                 |    Date Dimension   |
                 |---------------------|
                 | Date, Month, Year   |
                 +---------------------+
                           |
                           |
+----------------+   +----------------+   +----------------+
| Driver Dim     |   |   Orders Fact   |   | Customer Dim   |
|----------------|<->|----------------|<->|----------------|
| Name           |   | Revenue        |   | Name           |
| Age            |   | Delivery Time  |   | City           |
| City           |   | Order Count    |   | Segment        |
| Rating         |   +----------------+   +----------------+
+----------------+

( The fact table is the center of the cube, connected to multiple dimensions )

Imagine I work for a food delivery app. In our OLAP cube, the Orders Fact table holds the actual measures like total revenue and delivery time. We surround this with dimensions like Driver, Customer, and Date. 
Each dimension has attributes — for example, the Driver dimension has Name, Age, City, and Rating. These attributes allow us to slice and dice the fact data.
For instance, I can analyze average delivery time by driver age group, or total revenue by customer city, or monthly delivery performance.

Each attribute actually maps to a property of the entity from the operational system. In other words, if the driver class in our backend has a property called City, 
it will become the City attribute inside the OLAP dimension. This is how OLAP cubes structure data for fast and flexible reporting.


Types of schemas :-

There are three main types of schemas commonly used in data warehouses: Star Schema, Snowflake Schema, and Galaxy Schema.

Dimensions - that provide context to facts (measurable business events).

Attributes - Each dimension has attributes that provide more details. 

Measures - Quantifiable (numerical values) Business Data 


Example case study :- UBER Ride App 

Fact Table = Foreign Keys from Dimensions + Metrics (measurable data).

Dimension Table = Descriptive attributes that provide context.



Data Warehouse :- 

Data Warehouse :- Snowflake,  Amazon Redshift, Google BigQuery, Databricks SQL Warehouse, Apache Druid

| **Data Warehouse**  | **Used By**                  | **Best For**                           | **Strengths**                                                        | **Storage Format**      | **Query Engine**     |
| ------------------- | ---------------------------- | -------------------------------------- | -------------------------------------------------------------------- | ----------------------- | -------------------- |
| **Snowflake**       | Adobe, DoorDash, Capital One | General-purpose warehousing, BI        | Serverless, auto-scaling, semi-structured support, time travel       | Proprietary + Parquet   | Cloud-native         |
| **Amazon Redshift** | Lyft, Yelp, Nasdaq           | Traditional OLAP workloads             | Tight AWS integration, Spectrum for S3, concurrency scaling          | Columnar (Redshift), S3 | PostgreSQL-based MPP |
| **Google BigQuery** | Spotify, Twitter, Home Depot | Ad-hoc SQL analytics, ML pipelines     | Serverless, pay-per-query, native ML, massive scalability            | Columnar (Capacitor)    | Dremel-based         |
| **Databricks SQL**  | Comcast, Regeneron, Shell    | Unified batch/streaming & ML workloads | Delta Lake ACID, notebooks, MLflow, real-time jobs on lakehouse      | Delta Lake (Parquet)    | Photon (Vectorized)  |
| **Apache Druid**    | Netflix, Confluent           | Time-series, real-time dashboards      | Sub-second queries, stream ingestion, roll-ups, pre-aggregation      | Columnar (Druid native) | Query + Index engine |

Databricks SQL and Apache Druid can run on prem as well, rest all are cloud native. 


Data Lake and Data Warehouse both being used by organizations :- 


| **Aspect**      | **Data Lake**                                   | **Data Warehouse**                           |
| --------------- | ----------------------------------------------- | -------------------------------------------- |
| **Purpose**     | Store raw, semi-structured & unstructured data  | Store curated, structured data for analytics |
| **Data Types**  | Images, logs, clickstreams, JSON, Parquet, etc. | Cleaned tabular data (e.g., fact/dim tables) |
| **Cost**        | Cheaper (cold storage like S3, ADLS)            | More expensive (compute & storage managed)   |
| **Schema**      | Schema-on-read (flexible)                       | Schema-on-write (strict)                     |
| **Usage**       | Data science, ML pipelines, raw ingestion       | BI dashboards, reporting, OLAP queries       |
| **Performance** | Slower for querying unless optimized            | Fast, indexed, optimized for analytics       |



1 


| **ETL Step**  | **What Happens**                                       | **Example**                                                    |
| ------------- | ------------------------------------------------------ | -------------------------------------------------------------- |
| **Extract**   | Pull raw data from various sources.                    | Logs from Kafka, events from APIs, files from S3.              |
| **Transform** | Clean, join, enrich, filter, deduplicate the data.     | PySpark or dbt jobs transform the raw data into usable tables. |
| **Load**      | Save the clean, structured data into a data warehouse. | Write final tables to **Snowflake** (or BigQuery, Redshift).   |



How to optimize the query speed in snowflake after the spark + iceberg - Use case of performance tuning 


2 


File formats and table formats:- 

| File Format | Type             | Usage Context                              |
| ----------- | ---------------- | ------------------------------------------ |
| **CSV**     | Row Based        | Simple flat files, small data, quick loads |
| **JSON**    | Semi-structured  | Logs, web data, flexible schema            |
| **Avro**    | Row-based binary | Kafka, streaming data, schema evolution    |
| **Parquet** | Columnar         | Analytics, Spark, Hive, AWS Athena, etc.   |
| **ORC**     | Columnar         | Optimized for Hive, better compression     |
| **Delta**   | Table format     | Databricks-native, versioned tables        |
| **Iceberg** | Table format     | Open table format with schema evolution    |
| **Hudi**    | Table format     | Incremental data processing, updates       |


Columnar vs Row Based:-

columnar storage was before parquet as well 

parquet introduces something called row group 

columnar storage depending upon the query ask just selects the columns that are required for the output 





























