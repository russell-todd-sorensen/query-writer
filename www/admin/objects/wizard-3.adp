<master src="wizard-master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<div class="app">

<h3>Add Group</h3>

<form action="/qw/qw" method="post">

 <input type="hidden" name="return_url" value="/qw/admin/objects/wizard-3?object_id=@object_id@">
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <td colspan="3" width="600">
  <p>A group is a collection of attributes with the actions that can be
  performed on the attribute. When a request is processed a single
  group picked and used to verify the user has access to the group.
  <p>The Admin group is only available to admin users. The default group
  is available to all registered users. 
  <p>If you need an additional group for your application, you should 
  add it here. When you submit forms to the query-writer you should
  will need to include a signed variable named qw_group_id to
  indicate which group to use, otherwise one of the two built in
  groups will be chosen based on admin privileges on the package
  instance of the query-writer package. 
  <td>
 </tr>
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

</table>



<div class="functnbar3">
<input type="submit" value="Add Group">
</div>
</form>

<div class="app">

<h3>Choose from Current Groups</h3>
<form action="wizard-4" method="post">
 <input type="hidden" name="object_id" value="@object_id@">
<table cellspacing="0" cellpadding="3" border="1">
<tr>
 <th>Group ID</th>
 <th>Group Name</th>
 <th>Choose</th>
</tr>
<multiple name="groups">
 <tr>
  <td>@groups.group_id@</td>
  <td>@groups.name@</td>
  <td><input type="checkbox" name="group.@groups.group_id@"></td>
 </tr>
</multiple>
</table>
<div class="functnbar3">
<input type="submit" value="Select Groups and Continue">
</div>
</form>

</div>

