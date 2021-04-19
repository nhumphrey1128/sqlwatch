﻿CREATE VIEW [dbo].[vw_sqlwatch_report_fact_xes_long_queries] with schemabinding
as

SELECT
       event_time
      ,[event_name]
      ,[session_id]
      ,[database_name]
      ,[cpu_time]
      ,[physical_reads]
      ,[logical_reads]
      ,[writes]
      ,[spills]
      ,[offset]
      ,[offset_end]
      --,[statement]
      ,[username]
      --,[sql_text]
      ,[object_name]
      ,[client_hostname]
      ,[client_app_name]
      ,[duration_ms]
      --,[wait_type]
      ,report_time
      ,d.[sql_instance]
      ,[long_query_id]
 --for backward compatibility with existing pbi, this column will become report_time as we could be aggregating many snapshots in a report_period
, d.snapshot_time
, d.snapshot_type_id

    , qp.query_plan
    , qt.sql_text
  FROM [dbo].[sqlwatch_logger_xes_long_queries] d
  	inner join dbo.sqlwatch_logger_snapshot_header h
		on  h.snapshot_time = d.[snapshot_time]
		and h.snapshot_type_id = d.snapshot_type_id
		and h.sql_instance = d.sql_instance

    left join dbo.sqlwatch_meta_query_plan qp
        on qp.sql_instance = d.sql_instance
        and qp.sqlwatch_query_plan_id = d.sqlwatch_query_plan_id

    left join dbo.sqlwatch_meta_query_text qt
        on qt.sql_instance = d.sql_instance
        and qt.sqlwatch_query_id = d.sqlwatch_query_id
