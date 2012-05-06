select tablespace_name, sum(blocks) Totalblocks, sum(bytes)TotalBytes from DBA_SEGMENTS  group by tablespace_name;
