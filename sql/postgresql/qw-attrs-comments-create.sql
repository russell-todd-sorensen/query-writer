-- qw-attrs-comments-create.sql

-- Create Query Writer Attributes Data Model Comments
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 28 January 2002
-- @cvs-id $Id: qw-attrs-comments-create.sql,v 1.3 2002/02/07 20:36:21 nsadmin Exp $
--


comment on table qw_attrs is '
  The qw_attrs table maintains object attributes. There should
be one attribute for each input for all the object functions. 
In oracle an object is usually an Oracle package. In PG, objects
are a collection of functions with a common beginning, followed
by a double underscore. I.E.:
 oracle package product has the following internal functions:
 product.new
 product.set_attrs
 product.reset_attr
 product.product_p
 product.delete
In PG, there will be a series of functions:
 product__new
 product__set_attrs
 product__reset_attr
 product__product_p
 product__delete
';

comment on column qw_attrs.attr_id is '
  Attr_id is the outwardly visible name for the attribute
this might be different from the actual attribute name, attr.
The attr_id is the value which will be included in form variable
names.';

comment on column qw_attrs.filters is '
  This is a comma seprated list of filters exactly the same as
will be used in ad_page_contract following an input query variable.
  If in ad_page_contract an input variable was defined as:
--
  product_id:integer,notnull
--
  The filter field here, for the attr ''product_id'' would be:
--
  integer,notnull
';


comment on column qw_attrs.values is '
  This field is used to specify which values an attribute are allowed.
If all values are allowed for all groups of users, then this field
should remain null. The values here are similar to a check constraint
on a field with a limited number of values. Usually administrators will
be allowed to give any value to this field, whereas regular users might
be more limited.
  For example, product.state field might be allowed to have values
of 0-5, where 0 means ''not available''. This designation might not be
allowed by regular users. In this example, this field would have the 
value of ''0 1 2 3 4 5'', a space separated list. The qw_group_attr_map
will not map the value 0 to the regular user group.
';

comment on column qw_attrs.length is '
  The length field is used in the case of input attributes
that have a maximum length that is likely to be exceeded by some
user inputs. A separate filter is run on any attribute that has
an integer value in this field. Leave this field null in the
case of ''text'', ''integer'' and ''numeric'' datatypes.
';

comment on column qw_attrs.description is '
  Human language name for this attribute. This can be used to 
label the attribute for users. This is used in the filter system
to identify which attribute value is not valid.
';
