<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>



<table cellspacing="0" cellpadding="1" border="0" >

<multiple name="functions">
 <tr>
  <th align="left">
   <p>Object: 
   <a href="add?object_id=@functions.object_id@">@functions.object@</a>
  </th>
 </tr>
 <tr>
  <td>
   <table cellspacing="0" cellpadding="3" border="1" width="600">
     <tr>
      <th>Function Name</th>
      <th>Type</th>
      <th>Description</th>
      <th>Joiner</th>
      <th>Active</th>
     </tr>
    <group column="object_id">
     <tr>
      <td><a href="../fn-attrs/add?fn_id=@functions.fn_id@">@functions.name@</a></td>
      <td>@functions.type_description@</td>
      <td>@functions.description@</td>
      <td>@functions.joiner@</td>
      <td><if @functions.active_p@ eq 1>Yes</if><else>No</else></td>
     </tr>
    </group>
   </table>
  </td>
 </tr>
</multiple>
</table>
