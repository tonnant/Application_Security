select 'Select count(*) from ' ||owner|| '.' ||table_name|| ';' from dba_all_tables order by owner, table_name;
