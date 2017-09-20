<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<form action="/qw/qw" method="post">
<input type="hidden" name="return_url" value="/qw/admin/groups/add">
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <th>Group ID</th>
  <td><input type="text" name="new.qw_group.id.0" value="" size="4" maxlength="10">
  </td>
 </tr>
 <tr>
  <th>Group Name</th>
  <td><input type="text" name="new.qw_group.name.0" value="" size="30" >
  </td>
 </tr>
 <tr>
  <th colspan="2"><input type="submit" value="Add Group" ></th>
 </tr>
</table>

</form>



<h3>Current Groups</h3>
<form action="/qw/qw" method="post">
 <input type="hidden" name="return_url" value="/qw/admin/groups/add">
<table cellspacing="0" cellpadding="3" border="1">
<tr>
 <th>Group ID</th>
 <th>Group Name</th>
 <th>Delete</th>
</tr>
<multiple name="groups">
 <tr>
  <td>@groups.group_id@</td>
  <td>@groups.name@</td>
  <td>
    <input type="checkbox" name="del.qw_group.@groups.group_id@" value="1">
  </td>
 </tr>
</multiple>
 <tr>
  <th colspan="3"><input type="submit" value="Delete Checked Groups"></th>
 </tr>
</table>
</form>
