<master src="wizard-master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<form action="/qw/qw" method="post">
<input type="hidden" name="return_url" value="/qw/admin/objects/wizard-3?object_id=@object_id@">

<div class="app">
<h3>Add Attributes</h3>

<table cellspacing="0"  border="1" cellpadding="2">

<multiple name="attributes">
 <tr>
  <th colspan="11">Table: @attributes.table_name@</th>
 </tr>
 <tr>
  <th>Order</th>
  <th>Attr Name</th>
  <th>Form Var ID</th>
  <th>Datatype</th>
  <th>Varchar Max</th>
  <th>Filters</th>
  <th>Required</th>
  <th>Default</th>
  <th>Value List ;</th>
  <th>Descr.</th>
  <th>Help Text</th>
 </tr>
  <group column="table_name">
  <if @attributes.exclude@ eq "0">
  <input type="hidden" name="new.qw_attr.objectid.@attributes.rownum@" value="@object_id@">
  <input type="hidden" name="new.qw_attr.attr_table.@attributes.rownum@" value="@attributes.table_name@">
 <tr class="<if @attributes.rownum@ odd>a</if><else>b</else>">
  <td><input type="text" name="new.qw_attr.attr_order.@attributes.rownum@" value="@attributes.rownum@" size="3"></td>
  <td>@attributes.attname@</td>
  <td><input type="hidden" name="new.qw_attr.attr.@attributes.rownum@" value="@attributes.attname@">
      <input type="text" name="new.qw_attr.id.@attributes.rownum@" value="@attributes.attname@" size="10"></td>
  <td><input type="text" name="new.qw_attr.datatype.@attributes.rownum@" value="@attributes.typname@" size="10"></td>
  <td><if @attributes.length@ gt 0><input type="text" name="new.qw_attr.length.@attributes.rownum@" value="@attributes.length@" size="5"></if>
      <else>N/A</else></td>
  <td><input type="text" name="new.qw_attr.filters.@attributes.rownum@" value="@attributes.filters@" size="10"></td>
  <td><if @attributes.attnotnull@ eq t and @attributes.atthasdef@ eq f>Required</if><else>Optional</else></td>
  <td><input type="text" name="new.qw_attr.default.@attributes.rownum@" value="@attributes.default@" size="10"></td>
  <td><input type="text" name="new.qw_attr.values.@attributes.rownum@" value="" size="10"></td>
  <td><input type="text" name="new.qw_attr.description.@attributes.rownum@" value="@attributes.attname@" size="10"></td>
  <td><input type="text" name="new.qw_attr.help.@attributes.rownum@" value="" size="10"></td>

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
