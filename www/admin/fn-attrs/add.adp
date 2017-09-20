<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<table cellspacing="0" cellpadding="1" border="1">
 <tr>
  <th>Attribute</th>
  <th>Default Value</th>
  <th>Attribute Order</th>
  <th colspan="2">Actions</th>
 </tr>
<multiple name="attrs">
<form action="edit-2" method="post">
<input type="hidden" name="return_url" value="/qw/admin/fn-attrs/add?fn_id=@fn_id@"> 
<input type="hidden" name="fn_id" value="@fn_id@">
 <tr>
  <td>
   <input type="text" name="attr" value="@attrs.attr@" size="15">
  </td>
  <td>
   <input type="text" name="default_value" value="@attrs.default_value@" size="10">
  </td>
  <td>
   <input type="text" name="attr_order" value="@attrs.attr_order@" size="5">
  </td>
  <td>
   <input type="submit" value="Update"></form>
  </td>
  <td>
   <form action="delete" method="post">
    <input type="hidden" name="fn_id" value="@fn_id@">
    <input type="hidden" name="attr" value="@attrs.attr@">
    <input type="submit" value="Remove">
   </form>
  </td>
 </tr>

</multiple>
 <tr>
  <th colspan="5" align="left">
   <p>The attributes below can be added to the function definition.
  </th>
 </tr>
<multiple name="all_attrs">
<tcl>set row $all_attrs(rownum); set arr all_attrs:$row ; set this_attr [set ${arr}(attr)];
if {[lsearch $attr_list $this_attr] > -1} {set skip 1} else { set skip 0}</tcl>
<if @skip@ eq 0 >
<form action="/qw/qw" method="post">
<input type="hidden" name="return_url" value="/qw/admin/fn-attrs/add?fn_id=@fn_id@">
<input type="hidden" name="new.fn_attr.fnid.0" value="@fn_id@">
 <tr>
  <td>
   <input type="text" name="new.fn_attr.attr.0" value="@all_attrs.attr@" size="15">
  </td>
  <td>
   <input type="text" name="new.fn_attr.default.0" value="@all_attrs.default_value@" size="10">
  </td>
  <td>
   <input type="text" name="new.fn_attr.order.0" value="" size="5">
  </td>
  <th colspan="2">
   <input type="submit"  value="Add">
  </th>
 </tr>
</form>
</if>
</multiple>
</table>

