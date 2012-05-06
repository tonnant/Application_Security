select owner,tablespace_name,segment_name,bytes,extents,max_extents from dba_segments where extents*2 > max_extents;
