select
 att.attname,
 att.attnum,
 typ.typname,
 (att.atttypmod - 4) as length,
 att.attnotnull,
 att.atthasdef
from
 pg_attribute att,
 pg_type typ
where
 att.attrelid = 210288 and -- :table_oid
 att.attnum > 0 and
 att.atttypid = typ.oid 
order by att.attnum