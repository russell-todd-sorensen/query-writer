<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<form action="add-2" method="post">
 
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <th>Object ID:</th>
  <td><input type="text" name="object_id" value="" size="40"></td>
 </tr>
 <tr>
  <th>Object:</th>
  <td><input type="text" name="object" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Object Table:</th>
  <td><input type="text" name="obj_table" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Key:</th>
  <td><input type="text" name="key" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Eval After:</th>
  <td><input type="text" name="to_eval" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Update Perm Check:</th>
  <td><input type="text" name="" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Delete Perm Check:</th>
  <td><input type="text" name="" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Operations:</th>
  <td><input type="text" name="ops" value="new;set;del" size="40"></td>
 </tr> 
 <tr>
  <th>New Function Name:</th>
  <td><input type="text" name="new_fn" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Set Function Name:</th>
  <td><input type="text" name="set_fn" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Del Function Name:</th>
  <td><input type="text" name="del_fn" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Rst Function Name:</th>
  <td><input type="text" name="rst_fn" value="" size="40"></td>
 </tr> 
 <tr>
  <th>Permission_P?</th>
  <td>
    <ul>
      <li><input type="radio" value="1" name="perm_p" checked> Use Permission_p
      <li><input type="radio" value="0" name="perm_p" > Do Not Use Permission_p
    </ul>
  </td>
 </tr> 
 <tr>
  <th colspan="2"><input type="submit" value="Add Object"></th>
 </tr> 
</table>
</form>

<h3>Current Objects</h3>

<table cellspacing="0" cellpadding="3" border="1">
<tr>
 <th>Object</th>
 <th>Functions</th>
 <th>Table</th>
 <th>Key</th>
 <th>Eval</th>
 <th>Set Perms</th>
 <th>Del Perms</th>
 <th>Operations</th>
 <th>New Fn</th>
 <th>Set Fn</th>
 <th>Del Fn</th>
 <th>Rst Fn</th>
 <th>Permission_P</th>
</tr>
<multiple name="objects">
 <tr>
  <td><a href="one?object_id=@objects.object_id@">@objects.object@</a></td>
  <td><a href="pg-create?object_id=@objects.object_id@">@objects.object@</a></td>
  <td>@objects.obj_table@</td>
  <td>@objects.key@</td>
  <td>@objects.to_eval@</td>
  <td>@objects.set_perm_check@</td>
  <td>@objects.del_perm_check@</td>
  <td>@objects.ops@</td>
  <td>@objects.new_fn@</td>
  <td>@objects.set_fn@</td>
  <td>@objects.del_fn@</td>
  <td>@objects.rst_fn@</td>
  <td>@objects.perm_p@</td>
 </tr>
</multiple>

</table>
