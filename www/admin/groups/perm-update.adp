<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<h3>New Permissions</h3>




<multiple name="perms">


<h3>Group @perms.group_id@</h3>
<table cellspacing="0" cellpadding="1" border="1">
 <tr>
  <th>Attribute</th>
  <th>Values</th>
  <th>Operations</th>
  <th>Update</th>
 </tr>

<group column="group_id">
 <tr>
<form action="perm-update-2" method="post">
<input type="hidden" name="return_url" value="@return_url@">
  <th>@perms.attr@</th>
   <input type="hidden" name="attr_id" value="@perms.attr_id@">
   <input type="hidden" name="object_id" value="@perms.object_id@">
   <input type="hidden" name="group_id" value="@group_id@">
  <td>
  <input type="text" name="values" value="@perms.values@">
  </td>
  <td>
  <input type="text" name="ops" value="@perms.ops@">
  </td>
  <td><input type="submit" value="Update"></td>
</form>
 </tr>
</group>
</table>
</multiple>



</form>
