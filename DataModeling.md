## SmartDraw tool used to data model

- Work with all the business teams, and their core operational business
- We design and deliver solutions building the data models from scratch
- translate business requirements into data pipelines
##
- design a data model for AirBnB
- pupropse of this data
- transactional or analytical
- analytical purposes for data warehousing

##
- schema -- star schema -- denormalized -- operations faster -- not optimal for storage
- snowflake schema -- normalized data -- reduces redundancy -- but uses more joins -- better for storage

## objectives to data model on 
- reviews to improve experience
- business profitablity -- pricing, revenue, optimization



## approach
- analytical purposes we will choose star schema
- what data to capture

  tables -- 1. review fact

  - review id (primary key)
  - listing id
  - name
 
  - 2. listing dim table (primary key)
       - 
- 3. user table
     - user_id (primary key)
    
- make multiple dimension and attribute tables



Explanation :- 

--------+
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



##modeling data for UBER :- 

- if the model design is not accurate then the query performance will never be accurate at the end of the day
- so let's take the example of a ride sharing app
- user books cabs and the driver picks and drops them to a desired location

  - first is to know the use cases
  - who are the users
  - impact of the use cases
 
  ### use cases
  - driver conversion rate (optimizing the driver onboarding process from signup to activation, trip request details)
  - the users will be --  data analysts, business problems, data scientist
  - business impact -- less driver onboarding time, trip related data to improve profits
  - 






##Using the tech stack for data modeling :- 

- In production, I design data models using a combination of dimensional modeling and modern data stack tools, focusing on scalability, performance, and alignment with business requirements.
- Snowflake as the cloud data warehouse. I native features like views, materialized views, and clustering/partitioning strategies for performance optimization.
-  I use Delta Lake for handling slowly changing dimensions (SCD), maintaining data versioning, and ensuring data quality through ACID transactions.
-  We process raw data using Scala and PySpark
-  dbt for managing transformation logic in SQL and organizing the data models into layers — staging, intermediate, and mart — with clear lineage, documentation, and testing.
-  For visualizing schema relationships/ logical architecture of schema Lucidchart/SmartDraw to align the model with business stakeholders.

































