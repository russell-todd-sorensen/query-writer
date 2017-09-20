<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<form action="/qw/qw" method="post">
<input type="hidden" name="new.qw_fn.oid.0" value="@object_id@">
<input type="hidden" name="return_url" value="/qw/admin/functions/add?object_id=@object_id@">
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <th>Function Name:</th>
  <td><input type="text" name="new.qw_fn.name.0" value="" size="40">
  </td>
 </tr>
 <tr>
  <th>Type:</th>
  <td>
   <select name="new.qw_fn.type.0">
   <multiple name="types">
    <option value="@types.type@">@types.name@ -- @types.description@</option>
   </multiple>
   </select>
  </td>
 </tr>
 <tr>
  <th>Description:</th>
  <td><input type="text" name="new.qw_fn.description.0" value="" size="40">
  </td>
 </tr>
 <tr>
  <th>Joiner:</th>
  <td><input type="text" name="new.qw_fn.joiner.0" value="" size="40">
  </td>
 </tr>
 <tr>
  <th>Active:</th>
  <td>
   <ul>
    <li><input type="radio" name="new.qw_fn.active.0" value="1" checked> Yes
    <li> <input type="radio" name="new.qw_fn.active.0" value="0"> No
   </ul>
  </td>
 </tr>
 <tr>
  <th colspan="2">
   <input type="submit" value="Add Function">
  </th>
 </tr>
</table>

</form>

<form action="/qw/qw" method="post">
<input type="hidden" name="return_url" value="/qw/admin/functions/add?object_id=@object_id@">

<table cellspacing="0" cellpadding="1" border="1">
<multiple name="functions">
 <if @functions:rowcount@ eq 0>
 <p>No Functions Defined
 </if>
 <else>
 <if @functions.rownum@ in "1$" >
 <tr>
  <th>Function Name</th>
  <th>Type</th>
  <th>Description</th>
  <th>Joiner</th>
  <th>Active</th>
  <th>Action</th>
 </tr>
 </if>
 </else>
 <tr>
  <td><a href="../fn-attrs/add?fn_id=@functions.fn_id@">@functions.name@</a></td>
  <td>@functions.type_name@</td>
  <td>@functions.description@</td>
  <td>@functions.joiner@</td>
  <td><if @functions.active_p@ eq 1>Yes</if><else>No</else></td>
  <td>Delete: <input type="checkbox" name="del.qw_fn.@functions.fn_id@"></td>
 </tr>

</multiple>
 <if @functions:rowcount@ gt 0>
 <tr>
  <th colspan="6"><input type="submit" value="Delete Checked Functions"></th>
 </tr>
 </if>
</table>


