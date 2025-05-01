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

         1. 

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



  2.

Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.

The result should be displayed by 'Id' ascending, and then by 'Month' descending.

Example
Input

| Id | Month | Salary |
|----|-------|--------|
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |
Output

| Id | Month | Salary |
|----|-------|--------|
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |


         approach :- 




with cte as(
select Id, Month,salary,
row_number() over(partition by id order by month desc) as nums
from EmployeeSalary) 

select id, month , sum(salary) over(PARTITION BY Id ORDER BY Month) from cte 
where nums != 1
order by id asc, month desc


takeaways 


1. sum(salary) over(PARTITION BY Id ORDER BY Month) from cte  - cumulative logic 
         2. order by id asc, month desc - this is done so that all id come together 






         3. Write a solution to find the top three wineries in each country based on their total points.



         Input: 
Sessions table:
+-----+-----------+--------+-----------------+
| id  | country   | points | winery          | 
+-----+-----------+--------+-----------------+
| 103 | Australia | 84     | WhisperingPines | 
| 737 | Australia | 85     | GrapesGalore    |    
| 848 | Australia | 100    | HarmonyHill     | 
| 222 | Hungary   | 60     | MoonlitCellars  | 
| 116 | USA       | 47     | RoyalVines      | 
| 124 | USA       | 45     | Eagle'sNest     | 
| 648 | India     | 69     | SunsetVines     | 
| 894 | USA       | 39     | RoyalVines      |  
| 677 | USA       | 9      | PacificCrest    |  
+-----+-----------+--------+-----------------+
Output: 
+-----------+---------------------+-------------------+----------------------+
| country   | top_winery          | second_winery     | third_winery         |
+-----------+---------------------+-------------------+----------------------+
| Australia | HarmonyHill (100)   | GrapesGalore (85) | WhisperingPines (84) |
| Hungary   | MoonlitCellars (60) | No second winery  | No third winery      | 
| India     | SunsetVines (69)    | No second winery  | No third winery      |  
| USA       | RoyalVines (86)     | Eagle'sNest (45)  | PacificCrest (9)     | 
+-----------+---------------------+-------------------+----------------------+

         

approach :-

         with cte as(
select country, winery, points, 
row_number() over(partition by country order by points desc) as rn 
from WineRatings) 


SELECT 
  country,
  COALESCE(MAX(CASE WHEN rn = 1 THEN CONCAT(winery, ' (', points, ')') END), 'No top winery') AS top_winery,
  COALESCE(MAX(CASE WHEN rn = 2 THEN CONCAT(winery, ' (', points, ')') END), 'No second winery') AS second_winery,
  COALESCE(MAX(CASE WHEN rn = 3 THEN CONCAT(winery, ' (', points, ')') END), 'No third winery') AS third_winery
FROM cte
group by country


         takeaways :- 
         1. case is used to convert from columns to rows 
         2. concat is a function to add columns together 
         3. coalesce to substitute the null values 
         4. MAX is used here to restrict to 1 row in the columns top_winery, second_winery, third_winery





         4. multiple tables question
         
         
         
         students table:

 +------------+------------------+------------------+
 | student_id | name             | major            |
 +------------+------------------+------------------+
 | 1          | Alice            | Computer Science |
 | 2          | Bob              | Computer Science |
 | 3          | Charlie          | Mathematics      |
 | 4          | David            | Mathematics      |
 +------------+------------------+------------------+
 
courses table:

 +-----------+-------------------+---------+------------------+----------+
 | course_id | name              | credits | major            | mandatory|
 +-----------+-------------------+---------+------------------+----------+
 | 101       | Algorithms        | 3       | Computer Science | yes      |
 | 102       | Data Structures   | 3       | Computer Science | yes      |
 | 103       | Calculus          | 4       | Mathematics      | yes      |
 | 104       | Linear Algebra    | 4       | Mathematics      | yes      |
 | 105       | Machine Learning  | 3       | Computer Science | no       |
 | 106       | Probability       | 3       | Mathematics      | no       |
 | 107       | Operating Systems | 3       | Computer Science | no       |
 | 108       | Statistics        | 3       | Mathematics      | no       |
 +-----------+-------------------+---------+------------------+----------+
 
enrollments table:

 +------------+-----------+-------------+-------+-----+
 | student_id | course_id | semester    | grade | GPA |
 +------------+-----------+-------------+-------+-----+
 | 1          | 101       | Fall 2023   | A     | 4.0 |
 | 1          | 102       | Spring 2023 | A     | 4.0 |
 | 1          | 105       | Spring 2023 | A     | 4.0 |
 | 1          | 107       | Fall 2023   | B     | 3.5 |
 | 2          | 101       | Fall 2023   | A     | 4.0 |
 | 2          | 102       | Spring 2023 | B     | 3.0 |
 | 3          | 103       | Fall 2023   | A     | 4.0 |
 | 3          | 104       | Spring 2023 | A     | 4.0 |
 | 3          | 106       | Spring 2023 | A     | 4.0 |
 | 3          | 108       | Fall 2023   | B     | 3.5 |
 | 4          | 103       | Fall 2023   | B     | 3.0 |
 | 4          | 104       | Spring 2023 | B     | 3.0 |
 +------------+-----------+-------------+-------+-----+
 


WITH
    T AS (
        SELECT student_id
        FROM enrollments
        GROUP BY 1
        HAVING AVG(GPA) >= 2.5
    )
SELECT student_id
FROM
    T
    JOIN students USING (student_id)
    JOIN courses USING (major)
    LEFT JOIN enrollments USING (student_id, course_id)
GROUP BY 1
HAVING
    SUM(mandatory = 'yes' AND grade = 'A') = SUM(mandatory = 'yes')
    AND SUM(mandatory = 'no' AND grade IS NOT NULL) = SUM(mandatory = 'no' AND grade IN ('A', 'B'))
    AND SUM(mandatory = 'no' AND grade IS NOT NULL) >= 2
ORDER BY 1;








         - feeding into sql tables first the datatypes and the columns, then the values with comma for all columns 
         - how to use having for multiple conditions 
         - in multiple tables always filter out the condition which gives the least rows 



5. stored procedures 

It is a precompiled and reusable set of database operations that can be called multiple times.

                  In contrast, a regular SQL query is compiled and optimized each time it is executed.

                  Stored procedures can include programming constructs such as conditional statements (IF-ELSE), loops,
                  and exception handling. Regular SQL queries focus on data retrieval, modification, or manipulation and do not have the same level of control flow capabilities


Manually called using CALL procedure_name() or via a Task. 



                  stored procedure in action :- 


                  CREATE OR REPLACE PROCEDURE flag_students_missing_mandatory_courses()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  -- Delete previous flags
  DELETE FROM students_to_review;

  -- Insert students who have not enrolled in all mandatory courses for their major
  INSERT INTO students_to_review (student_id, student_name, major, missing_courses, flagged_at)
  SELECT 
    s.student_id,
    s.name,
    s.major,
    COUNT(c.course_id) AS missing_courses,
    CURRENT_TIMESTAMP()
  FROM students s
  JOIN courses c
    ON s.major = c.major AND c.mandatory = 'yes'
  LEFT JOIN enrollments e
    ON s.student_id = e.student_id AND c.course_id = e.course_id
  WHERE e.course_id IS NULL
  GROUP BY s.student_id, s.name, s.major;

  RETURN 'Students flagged for missing mandatory courses.';
END;
$$;


explanation :- 
CREATE OR REPLACE PROCEDURE: Creates a new stored procedure or replaces the existing one.

RETURNS STRING: The procedure returns a string message at the end.

LANGUAGE SQL: This is written in SQL (you could also use JavaScript in Snowflake).

$$: Delimiters enclosing the SQL block.


         returns the string as a confirmation text that the stored procedure has run 



6. 

                                 CTE (WITH clause)	                    Temporary Table (CREATE TEMP TABLE)
        
🧠 Purpose	Logical, in-memory subquery used within a query	Physically exists (briefly) in the session

🔁 Reusability	Not reusable outside the single SQL statement	Reusable within the session for multiple queries

✅ DDL Allowed?	❌ No (can’t do CREATE TABLE, etc. inside CTE)	✅ Yes (you can CREATE, ALTER, etc.)



7. Distinct vs UNIQUE




8. Recursive CTE 

Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+

Result table:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+

The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 report his work indirectly to the head of the company 4 --> 2 --> 1.
The employee with employee_id 7 report his work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8 and 9 don't report their work to head of company directly or indirectly.


         


