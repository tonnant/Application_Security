select owner, sum(blocks) Totalblocks, sum(bytes)TotalBytes from DBA_SEGMENTS group by owner;
