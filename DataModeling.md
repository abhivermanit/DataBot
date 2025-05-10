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
     - 
