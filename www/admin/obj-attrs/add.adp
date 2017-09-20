<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<form action="add-2" method="post">
<input type="hidden" name="object_id" value="@object_id@"> 
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <th>Object ID:</th>
  <td>@object_id@</td>
 </tr> 
 <tr>
  <th>Attribute ID:</th>
  <td><input type="text" value="" name="attr_id" size="40"></td>
 </tr> 
 <tr>
  <th>Attribute:</th>
  <td><input type="text" value="" name="attr" size="40"></td>
 </tr> 
 <tr>
  <th>Attr Order</th>
  <td><input type="text" value="" name="attr_order" size="3"></td>
 </tr>
 <tr>
  <th>Table</th>
  <td><input type="text" value="" name="attr_table" size="40"></td>
 </tr>
 <tr>
  <th>Datatype</th>
  <td><select name="datatype">
       <option value="varchar">Varchar</option>
       <option value="integer">Integer</option>
       <option value="numeric">Numeric</option>
       <option value="character">Fixed Length Character</option>
       <option value="boolean">Boolean</option>
       <option value="timestamp">Date/Timestamp</option>
       <option value="text">Text (very long char)</option>
      </select>
   </td>
 </tr>
 <tr>
  <th>filters:</th>
  <td><input type="text" value="" name="filters" size="40"></td>
 </tr> 
 <tr>
  <th>values:</th>
  <td><input type="text" value="" name="values" size="40"></td>
 </tr> 
 <tr>
  <th>Default Value:</th>
  <td><input type="text" value="" name="default_value" size="40"></td>
 </tr> 
 <tr>
  <th>Max Length:</th>
  <td><input type="text" value="" name="length" size="40"></td>
 </tr>
 <tr>
  <th>Description:</th>
  <td><input type="text" value="" name="description" size="40"></td>
 </tr> 
 <tr>
  <th>Help text:</th>
  <td><input type="text" value="" name="help_text" size="40"></td>
 </tr> 

 <tr>
  <th colspan="2"><input type="submit" value="Add Attribute"></th>
 </tr> 
</table>
</form>


<if @attrs:rowcount@ gt 0>
<h3>Current Attributes</h3>

<table cellspacing="0" cellpadding="3" border="1">
<tr>
 <th>Action</th>
 <th>Attribute ID</th>
 <th>Attribute</th>
 <th>Filters</th>
 <th>Values</th>
 <th>Default Value</th>
 <th>Max Length</th>
 <th>Description</th>
 <th>Help Text</th>
</tr>
<multiple name="attrs">
 <tr>
  <td>
   <form action="delete" method="post">
   <input type="hidden" name="object_id" value="@attrs.object_id@">
   <input type="hidden" name="attr_id" value="@attrs.attr_id@">
   <input type="submit" value="Delete:">
   </form>
  </td>
  <td>
   <a href="edit?object_id=@object_id@&attr_id=@attrs.attr_id@">@attrs.attr_id@</a>
  </td>
  <td>@attrs.attr@</td>
  <td>@attrs.filters@</td>
  <td>@attrs.values@</td>
  <td>@attrs.default_value@</td>
  <td>@attrs.length@</td>
  <td>@attrs.description@</td>
  <td>@attrs.help_text@</td>
 </tr>
</multiple>
</table>
</if>
