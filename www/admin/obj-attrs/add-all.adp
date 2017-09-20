<master>
 
<h2>Object @object_id@</h2>
<h3>Info</h3>
<li>Table: @table@</li>
<li>Table OID: @table_oid@</li>

<form action="/qw/qw" method="post">
<input type="hidden" name="return_url" value="/qw/admin/objects/one?object_id=@object_id@">

<div class="app">
<h3>Attributes</h3>


<table cellspacing="0"  border="1" cellpadding="2">

<multiple name="attributes">
 <if @attributes.attname@ ne tree_sortkey >
 <tr>
  <th colspan="10">Table: @attributes.table_name@</th>
 </tr>
 <tr>
  <th>#</th>
  <th>Attr Name</th>
  <th>Attr ID</th>
  <th>Attr Type</th>
  <th>Length</th>
  <th>Required</th>
  <th>Default</th>
  <th>Value List (sep ;)</th>
  <th>Description</th>
  <th>Help Text</th>
 </tr>
 </if>
  <group column="table_name">
  <if @attributes.attname@ ne tree_sortkey >
  <input type="hidden" name="new.qw_attr.objectid.@attributes.rownum@" value="@object_id@">
 <tr class="<if @attributes.rownum@ odd>a</if><else>b</else>">
  <td>@attributes.attnum@</td>
  <td>@attributes.attname@</td>
  <td><input type="hidden" name="new.qw_attr.attr.@attributes.rownum@" value="@attributes.attname@">
      <input type="text" name="new.qw_attr.id.@attributes.rownum@" value="@attributes.attname@" size="15"></td>
  <td><input type="text" name="new.qw_attr.datatype.@attributes.rownum@" value="@attributes.typname@" size="15"></td>
  <td><if @attributes.length@ gt 0><input type="text" name="new.qw_attr.length.@attributes.rownum@" value="@attributes.length@" size="5"></if>
      <else>N/A</else></td>
  <td><if @attributes.attnotnull@ eq t and @attributes.atthasdef@ eq f>Required</if><else>Optional</else></td>
  <td><input type="text" name="new.qw_attr.default.@attributes.rownum@" value="@attributes.default@" size="15"></td>
  <td><input type="text" name="new.qw_attr.values.@attributes.rownum@" value="" size="15"></td>
  <td><input type="text" name="new.qw_attr.description.@attributes.rownum@" value="@attributes.attname@" size="15"></td>
  <td><input type="text" name="new.qw_attr.help.@attributes.rownum@" value="" size="15"></td>

 </tr>
  </if>
  </group>  

</multiple>

</table>

</div>

<div class="functnbar3">
<input type="submit" value="Add Attributes">
</div>
</form>
