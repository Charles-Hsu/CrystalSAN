proc parse_xml_cli_mirror {args} {

#$cli_mirror_section $site_name $engine_name $seconds

set cli_mirror_section [lindex $args 0]
set site_name [lindex $args 1]
set engine_name [lindex $args 2]
set seconds [lindex $args 3]
set serial [lindex $args 4]

puts "[exec date]=== parse_cli_mirror start..."

#puts $cli_mirror_section

set mirror_count [expr [llength [lindex $cli_mirror_section 2]]-3]
#puts "mirror_count=$mirror_count"

set i 0
set sql "insert into engine_cli_mirror values ('$serial',$seconds"
for {} {$i < $mirror_count} {incr i 1} {
append sql ","
#puts [lindex [lindex $cli_mirror_section 2] $i]
set mirror_data [lindex [lindex $cli_mirror_section 2] $i]
set mirror_status [lindex [lindex $mirror_data 2] 1]
set mirror_map [lindex [lindex $mirror_data 2] 2]
set mirror_capacity [lindex [lindex $mirror_data 2] 3]
#puts "mirror_$i"
#puts "id_$i=[lindex [lindex $mirror_data 1] 1]"
append sql "[lindex [lindex $mirror_data 1] 1]"
#puts "[lindex $mirror_status 0]_$i=[lindex [lindex [lindex $mirror_status 2] 0] 1]"
append sql ",'[lindex [lindex [lindex $mirror_status 2] 0] 1]'"
#puts "[lindex $mirror_map 0]_$i=[lindex [lindex [lindex $mirror_map 2] 0] 1]"
append sql ",[lindex [lindex [lindex $mirror_map 2] 0] 1]"
#puts "[lindex $mirror_capacity 0]_$i=[lindex [lindex [lindex $mirror_capacity 2] 0] 1]"
append sql ",[lindex [lindex [lindex $mirror_capacity 2] 0] 1]"
#puts [lindex [lindex $mirror_data 2] 4]

set j 0
#puts "[lindex [lindex [lindex [lindex $mirror_data 2] 4] 1] 0]_$i-$j=[lindex [lindex [lindex [lindex $mirror_data 2] 4] 1] 1]"
#puts "[lindex [lindex [lindex [lindex $mirror_data 2] 4] 1] 0]_$i-$j-status=[lindex [lindex [lindex [lindex [lindex [lindex [lindex $mirror_data 2] 4] 2] 1] 2] 0] 1]"
#puts [lindex [lindex $mirror_data 2] 5]
append sql ",[lindex [lindex [lindex [lindex $mirror_data 2] 4] 1] 1],'[lindex [lindex [lindex [lindex [lindex [lindex [lindex $mirror_data 2] 4] 2] 1] 2] 0] 1]'"

incr j 1
#puts "[lindex [lindex [lindex [lindex $mirror_data 2] 5] 1] 0]_$i-$j=[lindex [lindex [lindex [lindex $mirror_data 2] 5] 1] 1]"
#puts "[lindex [lindex [lindex [lindex $mirror_data 2] 5] 1] 0]_$i-$j-status=[lindex [lindex [lindex [lindex [lindex [lindex [lindex $mirror_data 2] 5] 2] 1] 2] 0] 1]"
append sql ",[lindex [lindex [lindex [lindex $mirror_data 2] 5] 1] 1],'[lindex [lindex [lindex [lindex [lindex [lindex [lindex $mirror_data 2] 5] 2] 1] 2] 0] 1]'"
}
for {} {$i < 6} {incr i 1} {
append sql ",'','','','','','','',''"
}

set mirror_ok_data [lindex [lindex $cli_mirror_section 2] $mirror_count]
set mirror_degraded_data [lindex [lindex $cli_mirror_section 2] [expr $mirror_count+1]]
set mirror_failed_data [lindex [lindex $cli_mirror_section 2] [expr $mirror_count+2]]

#puts "[lindex $mirror_ok_data 0]=[lindex [lindex [lindex $mirror_ok_data 2] 0] 1]"
append sql ",[lindex [lindex [lindex $mirror_ok_data 2] 0] 1]"

#puts "[lindex $mirror_degraded_data 0]=[lindex [lindex [lindex $mirror_degraded_data 2] 0] 1]"
append sql ",[lindex [lindex [lindex $mirror_degraded_data 2] 0] 1]"

#puts "[lindex $mirror_failed_data 0]=[lindex [lindex [lindex $mirror_failed_data 2] 0] 1]"
append sql ",[lindex [lindex [lindex $mirror_failed_data 2] 0] 1]"

append sql ")"

puts $sql
db eval $sql

puts "[exec date]=== parse_cli_mirror completed!"

}