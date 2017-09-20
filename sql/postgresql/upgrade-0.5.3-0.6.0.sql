alter table qw_attrs 
 add column attr_order integer;

alter table qw_attrs 
 add column attr_table varchar(64);

alter table qw_groups 
 add column rel_type varchar(100);

alter table qw_groups
 add constraint qwg_name_rel_type_un unique (name, rel_type);

update 
 qw_groups 
set 
 name = 'QW Admin',
 rel_type = 'membership_rel'
where
 group_id = 1;

insert into qw_groups 
 values (2,'Main Site Members','membership_rel');
