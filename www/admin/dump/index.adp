<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>


<form action="dump-all" method="post">
<p>Enter table prefix: <input type="text" value="" name="prefix">
<p><input type="submit" value="Dump All">
</form>

<h3>Query Writer Data</h3>

<p><a href="dump-all?prefix=qw_">Dump Query Writer data to file.</a>
<p><a href=load>Load Query Writer Data from file.</a> You need to do 
this only once when installing Query Writer.
