ad_page_contract {dummy}

set output [lsort [nsv_names qw* ]]
set out "<ul>"
foreach name $output {
    append out " 
     <li><a name=\"$name\">$name 
       <ul>"
		set elements [lsort [nsv_array names $name]]
    foreach element $elements {
      append out "
         <li>$element = '[nsv_get $name $element]'"
    }
    append out "</ul>"
}
append out "</ul>"
ad_return_template