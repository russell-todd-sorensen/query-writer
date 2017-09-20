<master src="wizard-master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<div class="app">

<h3>Map Group Permissions</h3>
</div>
<div class="colbar">
<form action="/qw/qw" method="post">

<input type="hidden" name="return_url" value="@return_url@">
<table cellspacing="0" cellpadding="1" border="1">
 <tr class="colbar">
  <th>&nbsp;</th>
  <list name="groups">
  <th colspan="2" align="center" id="ab">@groups:item@ Group</th>
  </list>
 </tr>
 <tr>
  <th>Attribute</th>
  <list name="groups">
  <th>Values</th>
  <th>Ops</th>
  </list>
 </tr>
<multiple name="attrs">
 <tr>
  <th>@attrs.attr@</th>
  <list name="group_list">
  <td>
  <input type="text" name="new.qw_group_attr_map.values.@attrs.rownum@@group_list:item@" value="" size="10">
  </td>
  <td>
  <input type="hidden" name="new.qw_group_attr_map.gid.@attrs.rownum@@group_list:item@" value="@group_list:item@">
  <input type="hidden" name="new.qw_group_attr_map.aid.@attrs.rownum@@group_list:item@" value="@attrs.attr_id@">
  <input type="hidden" name="new.qw_group_attr_map.oid.@attrs.rownum@@group_list:item@" value="@attrs.object_id@">
  <input type="text" name="new.qw_group_attr_map.ops.@attrs.rownum@@group_list:item@" 
   value="<if @group_list:item@ eq 1>@attrs.admin_ops@</if><else>@attrs.ops@</else>" size="10">
  </td>
  </list>

 </tr>
</multiple>


</table>
</div>
<div class="functnbar3">
<input type="submit" value="Map Group Permissions">
</div>
</form>
