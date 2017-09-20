select 
 column_name as attname,
 ordinal_position as attnum,
 data_type as typname,
 character_maximum_length as length,
 case 
  when column_default is null then 'f'
  else 't'
 end
 as atthasdef,
 case 
  when is_nullable = 'NO' then 't'
  else 'f'
 end 
 as attnotnull,
 column_default as "default"
 from 
  information_schema.columns
 where
  table_name = 'customers';
 