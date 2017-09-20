<master src="wizard-master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<div class="app">

<h3>Choose Procedural Language</h3>

<form action="wizard-5-1" method="post">

<input type="hidden" name="return_url" value="@return_url@">
<input type="hidden" name="object_id" value="@object_id@">
<table cellspacing="2" cellpadding="1" border="1" width="600">
 <tr class="a">
  <th>Tcl</th>
  <td colspan="4">Tcl wrapped dml and procedural language code will be used.
  Dynamically written dml statements will be used to create 
  modify and delete objects. Parent acs_objects will be accessed
  through pre-written tcl procedures. You will not need to define
  any functions to get the benefits of a procedural language 
  combined with the dynamic nature of dml. This is the most flexable
  method. </td>
 </tr>
 <tr class="b">
  <th>DML</th>
  <td colspan="4">Use SQL DML statements to create, modify and delete objects.
  Choose this method for non acs_objects. No procedural language
  will be used with this method. </td>
 </tr>
 <tr class="a" >
  <th>Plpgsql</th>
  <td colspan="4">Standard procedural language functions will be used to
  create modify and delete objects. Objects are derived from
  acs_objects. Choosing this method will require defining functions
  after you complete this wizard.</td>
 </tr>

<tr class="a">
 <th>Operation</th>
 <th>TCL</th>
 <th>DML</th>
 <th>PL</th>
 <th>PL Function Name (Used only when the method is PL)</th>
</tr>
<tr class="b">
 <th>Create/New</th>
 <td><input type="radio" name="type.new" value="pseudo" checked></td>
 <td><input type="radio" name="type.new" value="dml"></td>
 <td><input type="radio" name="type.new" value="pl"></td>
 <td><input type="text" name="new_fn" value="@new_fn@" size="40"></td>
</tr>
<tr class="a">
 <th>Update/Set</th>
 <td><input type="radio" name="type.set" value="pseudo" checked></td>
 <td><input type="radio" name="type.set" value="dml"></td>
 <td><input type="radio" name="type.set" value="pl"></td>
 <td><input type="text" name="set_fn" value="@set_fn@" size="40"></td>
</tr>
<tr class="b">
 <th>Delete/Del</th>
 <td><input type="radio" name="type.del" value="pseudo" checked></td>
 <td><input type="radio" name="type.del" value="dml"></td>
 <td><input type="radio" name="type.del" value="pl"></td>
 <td><input type="text" name="del_fn" value="@del_fn@" size="40"></td>
</tr>

<tr class="b">
 <th>Reset/Rst</th>
 <td><input type="radio" name="type.rst" value="pseudo" checked></td>
 <td><input type="radio" name="type.rst" value="dml"></td>
 <td><input type="radio" name="type.rst" value="pl"></td>
 <td><input type="text" name="rst_fn" value="@rst_fn@" size="40"></td>
</tr>
</table>

</div>
<div class="functnbar3">
<input type="submit" value="Map Function Types">
</div>

</form>
