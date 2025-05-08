| Data Source         | Used For                                  | Format                |
| ------------------- | ----------------------------------------- | --------------------- |
| **Parquet**         | Columnar storage, optimized for analytics | `.parquet`            |
| **Delta Lake**      | ACID on data lakes, schema evolution      | `.delta` (on S3/ADLS) |
| **ORC**             | Hive-native columnar format               | `.orc`                |
| **Avro**            | Row-based, good for Kafka/Schemas         | `.avro`               |
| **JSON**            | Semi-structured ingestion                 | `.json`               |
| **CSV**             | Light ETL, legacy pipelines               | `.csv`                |
| **Kafka**           | Streaming ingestion (real-time)           | Kafka broker          |
| **JDBC**            | RDBMS integration (OLTP/OLAP sources)     | MySQL, Postgres, etc  |
| **S3 / ADLS / GCS** | Object storage at scale                   | Filesystem layer      |

