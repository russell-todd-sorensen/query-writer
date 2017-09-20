select
 attname 
from 
 pg_attribute a
where
 a.attrelid = 210288;
--and
-- a.attnum = :index