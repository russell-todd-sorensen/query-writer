<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<form action="edit-2" method="post">
<input type="hidden" name="object_id" value="@object_id@"> 
<input type="hidden" name="attr_id" value="@attr_id@">
<table cellspacing="0" cellpadding="1" border="0">
 <tr>
  <th>Object ID:</th>
  <td>@object_id@</td>
 </tr> 
 <tr>
  <th>Attribute ID:</th>
  <td>@attr_id@</td>
 </tr> 
 <tr>
  <th>Attribute:</th>
  <td><input type="text" value="@attr@" name="attr" size="40"></td>
 </tr> 
 <tr>
  <th>Datatype</th>
  <td><select name="datatype">
       <option value="varchar" <if @datatype@ eq "varchar">selected</if>>Varchar</option>
       <option value="integer" <if @datatype@ eq "integer">selected</if>>Integer</option>
       <option value="numeric" <if @datatype@ eq "numeric">selected</if>>Numeric</option>
       <option value="character" <if @datatype@ eq "character">selected</if>>Fixed Length Character</option>
       <option value="boolean" <if @datatype@ eq "boolean">selected</if>>Boolean</option>
       <option value="timestamp" <if @datatype@ eq "timestamp">selected</if>>Date/Timestamp</option>
       <option value="text" <if @datatype@ eq "text">selected</if>>Text (very long char)</option>
      </select>
   </td>
 </tr>
 <tr>
  <th>filters:</th>
  <td><input type="text" value="@filters@" name="filters" size="40"></td>
 </tr> 
 <tr>
  <th>values:</th>
  <td><input type="text" value="@values@" name="values" size="40"></td>
 </tr> 
 <tr>
  <th>Default Value:</th>
  <td><input type="text" value="@default_value@" name="default_value" size="40"></td>
 </tr> 
 <tr>
  <th>Max Length:</th>
  <td><input type="text" value="@length@" name="length" size="40"></td>
 </tr>
 <tr>
  <th>Description:</th>
  <td><input type="text" value="@description@" name="description" size="40"></td>
 </tr> 
 <tr>
  <th>Help text:</th>
  <td><input type="text" value="@help_text@" name="help_text" size="40"></td>
 </tr> 

 <tr>
  <th colspan="2"><input type="submit" value="Edit Attribute"></th>
 </tr> 
</table>
</form>
