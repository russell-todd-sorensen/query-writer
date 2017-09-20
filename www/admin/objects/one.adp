<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<p><a href="../obj-attrs/add-all?object_id=@object_id@">Initial Bulk Add Attributes</a>
<p><a href="../obj-attrs/add?object_id=@object_id@">Add/Select Attributes</a>
<p><a href="../functions/add?object_id=@object_id@">Add Function for this object</a>
<p><a href="../groups/pick?object_id=@object_id@&final_form=perm-map">Map Group Permissions</a>
<p><a href="../groups/pick?object_id=@object_id@&final_form=perm-update">Update Group Permissions</a>
<form action="/qw/qw" method="post">
<input type="hidden" name="return_url" value="/qw/admin/objects/one?object_id=@object_id@">
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <th>Object:</th>
  <td><input type="text" name="set.qw_object.object.@object_id@" value="@object@" size="40"></td>
 </tr> 
 <tr>
  <th>Object Table:</th>
  <td><input type="text" name="set.qw_object.table.@object_id@" value="@obj_table@" size="40"></td>
 </tr> 
 <tr>
  <th>Key:</th>
  <td><input type="text" name="set.qw_object.key.@object_id@" value="@key@" size="40"></td>
 </tr> 
 <tr>
  <th>Eval After:</th>
  <td><textarea name="set.qw_object.eval.@object_id@" cols="38" rows="3" noscroll>@to_eval@</textarea></td>
 </tr> 
 <tr>
  <th>Update Perm Check:</th>
  <td><input type="text" name="set.qw_object.setperms.@object_id@" value="@set_perm_check@" size="40"></td>
 </tr> 
 <tr>
  <th>Delete Perm Check:</th>
  <td><input type="text" name="set.qw_object.delperms.@object_id@" value="@del_perm_check@" size="40"></td>
 </tr> 
 <tr>
  <th>Operations:</th>
  <td><input type="text" name="set.qw_object.ops.@object_id@" value="@ops@" size="40"></td>
 </tr> 
 <tr>
  <th>New Function Name:</th>
  <td><input type="text" name="set.qw_object.newfn.@object_id@" value="@new_fn@" size="40"></td>
 </tr> 
 <tr>
  <th>Set Function Name:</th>
  <td><input type="text" name="set.qw_object.setfn.@object_id@" value="@set_fn@" size="40"></td>
 </tr> 
 <tr>
  <th>Del Function Name:</th>
  <td><input type="text" name="set.qw_object.delfn.@object_id@" value="@del_fn@" size="40"></td>
 </tr> 
 <tr>
  <th>Rst Function Name:</th>
  <td><input type="text" name="set.qw_object.rstfn.@object_id@" value="@rst_fn@" size="40"></td>
 </tr> 
 <tr>
  <th>Permission_P?</th>
  <td>
    <ul>
      <li><input type="radio" value="1" name="set.qw_object.permp.@object_id@" <if @perm_p@ eq 1>checked</if>> Use Permission_p
      <li><input type="radio" value="0" name="set.qw_object.permp.@object_id@" <if @perm_p@ eq 0>checked</if>> Do Not Use Permission_p
    </ul>
  </td>
 </tr> 
 <tr>
  <th colspan="2"><input type="submit" value="Update Object"></th>
 </tr> 
</table>
</form>

