select
 indexrelid,
 indrelid,
 indkey,
 indclass,
 indisunique,
 indisprimary
from
 pg_index
where
 indrelid = 210288
and
 indisprimary = 't'