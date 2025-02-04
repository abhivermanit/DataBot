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

  





