1.
select
         rownumber,
         case when dashboard_name = 'KHX ROW Finishing - Fixed Projects' then 'KHX Finishing - Fixed Projects' else dashboard_name end as dashboard_name ,
         folder_name,
         vendor_name,
         apple_owner,
         layer,
         analytics_pipeline_name,
         refresh_frequency,
         case when dashboard_name = 'KHX Munin Operator User Prodcutivity (1st Iteration and Rework Details)' then 'P2' else  priority  end as priority
     from
         KH_BUILD_OPS_APP.DASHBOARDSMASTERLIST_SNOWFLAKE


// It checks if the dashboard_name is 'KHX Munin Operator User Prodcutivity (1st Iteration and Rework Details)'. If true, it sets the priority to 'P2'; otherwise, it retains the original priority.


2.
--For each unique combination of these three columns, a separate sequence of row numbers is generated.

-- Since there is no PARTITION BY clause, this function considers all rows in the result set. The max_refresh_date column will contain the same maximum LOAD_DATE_UTC value for every row in the result set.

select
                 *,
                 row_number() over(Partition by Workbook_or_Datasource_Subscriptions_Extract_Name,Date_ist,Project_Name Order by completed_time_ist) as ran
                     ,max(LOAD_DATE_UTC) over() as max_refresh_date


3. --Case Statement 

CASE 
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('ADDRESS_CHANGE', 'ADDRESS_ISSUE', 'STREET_NAME_CHANGE', 'NAME_ISSUE', 'DISPLAY_ISSUE', 
                                'LAYER_INGEST_OR_STITCH', 'DISPLAY_ISSUE_LANDCOVER', 'DISPLAY_ISSUE_BUILDINGS', 
                                'DISPLAY_ISSUE_WATER', 'BUILDING_REVIEW', 'ACTIVITY', 'PROBE_ROUTETEST', 
                                'PROBE_MISSED_MANEUVER', 'PEDESTRIAN_NAVIGATION_ISSUE', 'CYCLING_ISSUE', 
                                'MANEUVER_RESTRICTION', 'MISSING_TURN_RESTRICTION', 'STREETS_ISSUE', 
                                'SUGGESTED_DIRECTION_OF_TRAVEL', 'VEHICULAR_NAVIGATION_ISSUE', 'DANDELION_ROAD_CHANGE', 
                                'CYCLING_PROBE_ROUTETEST', 'CONGESTION_ZONE_CHANGE', 'CYCLING_BARRIER_ANOMALY', 
                                'TRAFFIC_CAMERA', 'VENDOR_STREET_CHANGE', 'CYCLING_OVER_INCLUSION', 'TERRITORY_ISSUE', 
                                'TERRITORY_CONFLATION') 
            AND UPPER("work_group") = 'MULTI' 
            THEN 'MULTI'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('ADDRESS_CHANGE', 'ADDRESS_ISSUE', 'STREET_NAME_CHANGE', 'NAME_ISSUE') 
            AND "is_fast_lane_enable" = 'False' 
            THEN 'Addressing'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('ADDRESS_CHANGE', 'ADDRESS_ISSUE', 'STREET_NAME_CHANGE', 'NAME_ISSUE') 
            AND "is_fast_lane_enable" = 'True' 
            THEN 'Addressing Fast Lane'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('DISPLAY_ISSUE', 'DISPLAY_ISSUE_LANDCOVER', 'DISPLAY_ISSUE_BUILDINGS', 'DISPLAY_ISSUE_WATER', 
                                'BUILDING_REVIEW', 'LAYER_INGEST_OR_STITCH', 'ACTIVITY') 
            THEN 'Display'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('PROBE_ROUTETEST', 'PROBE_MISSED_MANEUVER', 'PEDESTRIAN_NAVIGATION_ISSUE', 'CYCLING_ISSUE', 
                                'MANEUVER_RESTRICTION', 'MISSING_TURN_RESTRICTION', 'STREETS_ISSUE', 
                                'SUGGESTED_DIRECTION_OF_TRAVEL', 'VEHICULAR_NAVIGATION_ISSUE', 'DANDELION_ROAD_CHANGE', 
                                'CYCLING_PROBE_ROUTETEST', 'CONGESTION_ZONE_CHANGE', 'CYCLING_BARRIER_ANOMALY', 
                                'TRAFFIC_CAMERA', 'VENDOR_STREET_CHANGE', 'CYCLING_OVER_INCLUSION') 
            AND "is_fast_lane_enable" = 'False' 
            THEN 'Street'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('PROBE_ROUTETEST', 'PROBE_MISSED_MANEUVER', 'PEDESTRIAN_NAVIGATION_ISSUE', 'CYCLING_ISSUE', 
                                'MANEUVER_RESTRICTION', 'MISSING_TURN_RESTRICTION', 'STREETS_ISSUE', 
                                'SUGGESTED_DIRECTION_OF_TRAVEL', 'VEHICULAR_NAVIGATION_ISSUE', 'DANDELION_ROAD_CHANGE', 
                                'CYCLING_PROBE_ROUTETEST', 'CONGESTION_ZONE_CHANGE', 'CYCLING_BARRIER_ANOMALY', 
                                'TRAFFIC_CAMERA', 'VENDOR_STREET_CHANGE', 'CYCLING_OVER_INCLUSION') 
            AND "is_fast_lane_enable" = 'True' 
            THEN 'Street Fast Lane'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('TERRITORY_ISSUE', 'TERRITORY_CONFLATION') 
            THEN 'Territory'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('CONSTRUCTION_PROJECT', 'UNCATEGORIZED_ISSUE') 
            THEN 'Construction'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('MISSING_GEOMETRY') 
            THEN 'Missing Geo'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('INCIDENT_BASEMAP_REVIEW') 
            THEN 'INCIDENT_BASEMAP_REVIEW'
        WHEN UPPER("work_scope") NOT LIKE '%RAP%' 
            AND "todo_type" IN ('BRAVEHEART_FIXUP', 'GEMINI_POI', 'MANUAL_EDIT') 
            THEN 'Others'
        WHEN "todo_collection_id" IN ('986464525671727104', '959394714491027456') 
            AND "work_scope" IN ('RAP', 'RAP_VIP') 
            --AND "source_vendor" = 'KITTYHAWK' 
            AND LOWER("project_name") LIKE '%address%' 
            THEN 'RAP Address'
        WHEN "todo_collection_id" IN ('986464525671727104', '959394714491027456') 
            AND "work_scope" IN ('RAP', 'RAP_VIP') 
            --AND "source_vendor" = 'KITTYHAWK' 
            AND LOWER("project_name") LIKE '%territory%' 
            THEN 'RAP Territory'
        WHEN "todo_collection_id" IN ('986464525671727104', '959394714491027456') 
            AND "work_scope" IN ('RAP', 'RAP_VIP') 
            --AND "source_vendor" = 'KITTYHAWK' 
            AND (LOWER("project_name") NOT LIKE '%territory%' OR LOWER("project_name") NOT LIKE '%address%') 
            AND (LOWER("project_name") LIKE '%aoi%' OR LOWER("project_name") LIKE '%wilc%') 
            THEN 'RAP Display'
        ELSE 'RAP Streets' 
    END) AS "workstream" 


4. Some basic operations 

SUM((working_hrs + consulting_hrs)/3600000) AS productivity_hrs -- to add 2 columns and output a 3rd column 

AVG(CAST(throughput AS FLOAT) / CAST(productivity_hrs AS FLOAT)) AS productivity

5. Truncating the Date 

DATE_TRUNC('MONTH', DT) AS month 

DT	     Result of DATE_TRUNC('MONTH', DT)
2025-02-02	2025-02-01   -- the date is getting reset to the first of the month hence it can be grouped by for MoM data
2025-02-15	2025-02-01 
2025-03-10	2025-03-01
2025-01-28	2025-01-01
  

6. Avoiding the Group By 

select t.* from (

select a.*, max(b.edit_working_hrs) over(partition by b.ticket_id) as edit_working_hrs, -- over is being used to avoid group by 
max(b.edit_consulting_hrs) over(partition by b.ticket_id) as edit_consulting_hrs,
row_number()over(partition by a.ticket_id order by a.dt) as rnk
from MAPS_DATA_SEMANTIC_DB.KH_MAINTENANCE_OPS.EDIT_OVERVIEW_THROUGHPUT_BASE_1_ACTUAL_THROUGHPUT_FINAL a
left join maps1 b on a.ticket_id = b.ticket_id) t 

where t.rnk = 1

         
Why use OVER() instead of GROUP BY?
- Preserve row-level data:
- Multiple aggregations with different partitions:


7. where vs having 

select ticket_id, count(1) from maps1 group by ticket_id having count(1) > 1

where - filters rows before aggregation, works on row level data
having - can work on aggregated values





         

Interview Prep :- 

The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|1    | A          | 2341   |
|2    | A          | 341    |
|3    | A          | 15     |
|4    | A          | 15314  |
|5    | A          | 451    |
|6    | A          | 513    |
|7    | B          | 15     |
|8    | B          | 13     |
|9    | B          | 1154   |
|10   | B          | 1345   |
|11   | B          | 1221   |
|12   | B          | 234    |
|13   | C          | 2345   |
|14   | C          | 2645   |
|15   | C          | 2645   |
|16   | C          | 2652   |
|17   | C          | 65     |
+-----+------------+--------+
Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|5    | A          | 451    |
|6    | A          | 513    |
|12   | B          | 234    |
|9    | B          | 1154   |
|14   | C          | 2645   |
+-----+------------+--------+


My approach :- 

select id, company, case when nums%2 == 0 then num/2 as value else null,
case when nums%2 == 0 then (num/2 + 1) as value else null, 
case when nums%2 != 0 then (num/2 + 1) as value else null end as values
from (
 select id, company, salary, count(id) as nums,
 over(partition by company order by salary desc) as salary
 from company_salaries) a 
 having values not null


corrected approach :- 

WITH ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Company ORDER BY Salary) AS rn,
         COUNT(*) OVER (PARTITION BY Company) AS nums
  FROM company_salaries
),
median_rows AS (
  SELECT Id, Company, Salary, nums, rn
  FROM ranked
  WHERE 
    (nums % 2 = 1 AND rn = (nums + 1) / 2) OR
    (nums % 2 = 0 AND (rn = nums / 2 OR rn = nums / 2 + 1))
)
SELECT Id, Company, Salary FROM median_rows


takeaways :- 

- where condition can be used to filter and no need to keep that column in select 
- having cannot be used without agg 
- FWG HSD OL
- OVER is always accompanied by a function 
- 



























