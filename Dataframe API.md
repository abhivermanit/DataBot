| Data Source         | Used For                                  | Format                |
| ------------------- | ----------------------------------------- | --------------------- |
| **Parquet**         | Columnar storage, optimized for analytics | `.parquet`            |
| **Delta Lake**      | ACID on data lakes, schema evolution      | `.delta` (on S3/ADLS) |
|
| **JSON**            | Semi-structured ingestion                 | `.json`               |
| **CSV**             | Light ETL, legacy pipelines               | `.csv`                |
| **Kafka**           | Streaming ingestion (real-time)           | Kafka broker          |
| **JDBC**            | RDBMS integration (OLTP/OLAP sources)     | MySQL, Postgres, etc  |
| **S3 / ADLS / GCS** | Object storage at scale                   | Filesystem layer      |


Data Warehouse :- Snowflake,  Amazon Redshift, Google BigQuery, Databricks SQL Warehouse, Apache Druid

| **Data Warehouse**  | **Used By**                  | **Best For**                           | **Strengths**                                                        | **Storage Format**      | **Query Engine**     |
| ------------------- | ---------------------------- | -------------------------------------- | -------------------------------------------------------------------- | ----------------------- | -------------------- |
| **Snowflake**       | Adobe, DoorDash, Capital One | General-purpose warehousing, BI        | Serverless, auto-scaling, semi-structured support, time travel       | Proprietary + Parquet   | Cloud-native         |
| **Amazon Redshift** | Lyft, Yelp, Nasdaq           | Traditional OLAP workloads             | Tight AWS integration, Spectrum for S3, concurrency scaling          | Columnar (Redshift), S3 | PostgreSQL-based MPP |
| **Google BigQuery** | Spotify, Twitter, Home Depot | Ad-hoc SQL analytics, ML pipelines     | Serverless, pay-per-query, native ML, massive scalability            | Columnar (Capacitor)    | Dremel-based         |
| **Databricks SQL**  | Comcast, Regeneron, Shell    | Unified batch/streaming & ML workloads | Delta Lake ACID, notebooks, MLflow, real-time jobs on lakehouse      | Delta Lake (Parquet)    | Photon (Vectorized)  |
| **Apache Druid**    | Netflix, Confluent           | Time-series, real-time dashboards      | Sub-second queries, stream ingestion, roll-ups, pre-aggregation      | Columnar (Druid native) | Query + Index engine |

Databricks SQL and Apache Druid can run on prem as well, rest all are cloud native. 

