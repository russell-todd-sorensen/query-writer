<master src="wizard-master">
<property name="title">@title@</property>
<property name="context">@context@</property>


<form action="wizard-1-1" method="post">
 
<table cellspacing="0" cellpadding="2" border="1">
 <tr>
  <td>
<div class="app">

<h3>@title@</h3>

<table cellspacing="1" cellpadding="1" border="0">
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
<!-- Just collect minimum information 
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
-->
<input type="hidden" name="ops" value="new;set;del">
<input type="hidden" name="new_fn" value="__new">
<input type="hidden" name="set_fn" value="__set_attrs">
<input type="hidden" name="del_fn" value="__delete">
<input type="hidden" name="rst_fn" value="__reset_attrs">
<!--
 <tr>
  <th>Operations:</th>
  <td><input type="text" name="ops" value="new;set;del" size="40"></td>
 </tr> 
 <tr>
  <th>New Function Name:</th>
  <td><input type="text" name="new_fn" value="dummy" size="40"></td>
 </tr> 
 <tr>
  <th>Set Function Name:</th>
  <td><input type="text" name="set_fn" value="dummy" size="40"></td>
 </tr> 
 <tr>
  <th>Del Function Name:</th>
  <td><input type="text" name="del_fn" value="dummy" size="40"></td>
 </tr> 

 <tr>
  <th>Rst Function Name:</th>
  <td><input type="text" name="rst_fn" value="" size="40"></td>
 </tr> 
-->
 <tr>
  <th>Permission_P?</th>
  <td>
    <ul>
      <li><input type="radio" value="1" name="perm_p" checked> Use Permission_p
      <li><input type="radio" value="0" name="perm_p" > Do Not Use Permission_p
    </ul>
  </td>
 </tr> 

</table>

</div>

  </td>
 </tr>
</table>
<div class="functnbar3">
<input type="submit" value="Create Object">
</div>

</form>
