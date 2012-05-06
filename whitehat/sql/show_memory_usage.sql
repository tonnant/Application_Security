SELECT to_number(decode(SID,65535,NULL,SID)) SID,
operation_Type OPERATION,
trunc(work_area_size/1024) WSIZE,
trunc(expected_size/1024) ESIZE,
trunc(actual_mem_used/1024) MEM,
trunc(max_mem_used/1024) “MAX_MEM”
FROM v$sql_workarea_active
ORDER BY 1,2
/
