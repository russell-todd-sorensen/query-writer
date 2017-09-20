<master src="master">
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>

<form action="@final_form@" method="post">

<input type="hidden" name="object_id" value="@object_id@"> 
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <th>Pick Group</th>
  <td><select name="group_id">
<multiple name="groups">
       <option value="@groups.group_id@">@groups.name@</option>
</multiple>
      </select>
  </td>
 </tr>
</multiple>
 <tr>
  <th colspan="2"><input type="submit" value="Continue"></th>
 </tr>
</table>
      