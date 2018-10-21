-- qw-bootstrap-data.sql
-- Create Query Writer Bootstrap Data
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 22 February 2002
-- @cvs-id $Id: qw-bootstrap-data.sql,v 1.1 2002/02/23 00:05:02 nsadmin Exp $
--

-- REPLACE 3990 with a group number for the DEFAULT GROUP
-- The number itself is relatively meaningless.
--

-- qw_groups

insert into qw_groups (
 group_id,
 name
) 
values
(
 '1',
 'Admin'
);

insert into qw_groups (
 group_id,
 name
) 
values
(
 '3990',
 'Default'
);



-- qw_group_attr_map

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'product',
 'mfg_id',
 '',
 'del;new;set'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'product',
 'name',
 '',
 'del;new;set'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'product',
 'short_description',
 '',
 'del;new;set'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'product',
 'long_description',
 '',
 'del;new;set'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'product',
 'product_state',
 '',
 'del;new;set'
);

-- regular group


insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '3990',
 'product',
 'mfg_id',
 '',
 'new'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '3990',
 'product',
 'name',
 '',
 'new'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '3990',
 'product',
 'short_description',
 '',
 'new'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '3990',
 'product',
 'long_description',
 '',
 'new'
);

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '3990',
 'product',
 'product_state',
 '3;4',
 'new;set'
);

-- address object

insert into qw_objects (
 object_id,
 object,
 obj_table,
 key,
 to_eval,
 set_perm_check,
 del_perm_check,
 ops,
 new_fn,
 set_fn,
 del_fn,
 rst_fn,
 perm_p
 ) 
values 
(
 'address',
 'addrs',
 'dp_addresses',
 'address_id',
 'context_id;upvar user_id context_id',
 '',
 '',
 'del;set;new',
 'addrs__new',
 'addrs__set_attrs',
 'addrs__delete',
 'addrs__reset_attrs',
 '1'
);

-- addrs attributes
insert into qw_attrs (
 attr_id,
 object_id,
 attr,
 description,
 default_value,
 help_text,
 filters,
 values,
 length
)
values
(
 'name',
 'address',
 'name',
 'Address Name',
 '',
 'Identifies the address to the user. This is not used
  in the delivery.'
 '',
 '',
 100
);
insert into qw_attrs (
 attr_id,
 object_id,
 attr,
 description,
 default_value,
 help_text,
 filters,
 values,
 length
)
values
(
 'address',
 'address',
 'address',
 'Full Street Address',
 '',
 'The complete street address.'
 '',
 '',
 100
);

-- For the qw_group_attr_map object !!

insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'qw_group_attr_map',
 'aid',
 '',
 'new;set;del'
);
insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'qw_group_attr_map',
 'gid',
 '',
 'new;set;del'
);
insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'qw_group_attr_map',
 'oid',
 '',
 'new;set;del'
);
insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'qw_group_attr_map',
 'values',
 '',
 'new;set;del'
);
insert into qw_group_attr_map (
 group_id,
 object_id,
 attr_id,
 values,
 ops
)
values
(
 '1',
 'qw_group_attr_map',
 'ops',
 '',
 'new;set;del'
);
