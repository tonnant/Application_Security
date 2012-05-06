grant select on PERSON_TABLE to public with grant option;

select * from dba_tab_privs where TABLE_NAME = 'PERSON_TABLE'

select * from dba_role_privs where granted_role = 'PORTMAN_TABLE'
