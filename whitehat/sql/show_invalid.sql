select ‘ALTER ‘ || decode(object_type,’PACKAGE BODY’, ‘PACKAGE’,object_Type) ||’ ‘||object_name || ‘ COMPILE;’
from user_objects
where status = ‘INVALID’
and object_name not like ‘BIN$%’
