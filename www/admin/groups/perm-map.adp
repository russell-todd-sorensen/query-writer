<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<form action="/qw/qw" method="post">
<input type="hidden" name="return_url" value="@return_url@">
<table cellspacing="0" cellpadding="1" border="1">
 <tr>
  <th>Attribute</th>
  <th>Values</th>
  <th>Operations</th>
 </tr>
<multiple name="attrs">
 <tr>
  <th>@attrs.attr@</th>
   <input type="hidden" name="new.qw_group_attr_map.aid.@attrs.rownum@" value="@attrs.attr_id@">
   <input type="hidden" name="new.qw_group_attr_map.oid.@attrs.rownum@" value="@attrs.object_id@">
   <input type="hidden" name="new.qw_group_attr_map.gid.@attrs.rownum@" value="@group_id@">
  <td>
  <input type="text" name="new.qw_group_attr_map.values.@attrs.rownum@" value="@attrs.values@">
  </td>
  <td>
  <input type="text" name="new.qw_group_attr_map.ops.@attrs.rownum@" value="@ops@">
  </td>
 </tr>
</multiple>


</table>

<input type="submit" value="Set Permissions">
</form>
