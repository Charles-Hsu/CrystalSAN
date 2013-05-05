<?php
    
#  get_engine_cli_mirror_all.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $db = new SQLite3('server.db');
    $serial = $_GET['serial'];
    
    #$results = $db->query('SELECT site_name,ha_appliance_name,engine00,engine01,engine02,engine03,engine04 FROM ha_cluster');
    $results = $db->query("SELECT * FROM engine_cli_mirror WHERE serial='$serial'");
    /*
     CREATE TABLE engine_cli_mirror (serial text primary key, seconds integer,
     mirror_0_id integer, mirror_0_sts text, mirror_0_map integer, mirror_0_capacity integer, mirror_0_member_0_id integer, mirror_0_member_0_sts text, mirror_0_member_1_id integer, mirror_0_member_1_sts text,
     mirror_1_id integer, mirror_1_sts text, mirror_1_map integer, mirror_1_capacity integer, mirror_1_member_0_id integer, mirror_1_member_0_sts text, mirror_1_member_1_id integer, mirror_1_member_1_sts text,
     mirror_2_id integer, mirror_2_sts text, mirror_2_map integer, mirror_2_capacity integer, mirror_2_member_0_id integer, mirror_2_member_0_sts text, mirror_2_member_1_id integer, mirror_2_member_1_sts text,
     mirror_3_id integer, mirror_3_sts text, mirror_3_map integer, mirror_3_capacity integer, mirror_3_member_0_id integer, mirror_3_member_0_sts text, mirror_3_member_1_id integer, mirror_3_member_1_sts text,
     mirror_4_id integer, mirror_4_sts text, mirror_4_map integer, mirror_4_capacity integer, mirror_4_member_0_id integer, mirror_4_member_0_sts text, mirror_4_member_1_id integer, mirror_4_member_1_sts text,
     mirror_5_id integer, mirror_5_sts text, mirror_5_map integer, mirror_5_capacity integer, mirror_5_member_0_id integer, mirror_5_member_0_sts text, mirror_5_member_1_id integer, mirror_5_member_1_sts text,
     mirror_ok integer, mirror_degraded integer, mirror_failed integer);
     */
    
    
    // serial      seconds     mirror_0_id  mirror_0_sts  mirror_0_map  mirror_0_capacity  mirror_0_member_0_id  mirror_0_member_0_sts  mirror_0_member_1_id  mirror_0_member_1_sts  mirror_1_id  mirror_1_sts  mirror_1_map  mirror_1_capacity  mirror_1_member_0_id  mirror_1_member_0_sts  mirror_1_member_1_id  mirror_1_member_1_sts  mirror_2_id  mirror_2_sts  mirror_2_map  mirror_2_capacity  mirror_2_member_0_id  mirror_2_member_0_sts  mirror_2_member_1_id  mirror_2_member_1_sts  mirror_3_id  mirror_3_sts  mirror_3_map  mirror_3_capacity  mirror_3_member_0_id  mirror_3_member_0_sts  mirror_3_member_1_id  mirror_3_member_1_sts  mirror_4_id  mirror_4_sts  mirror_4_map  mirror_4_capacity  mirror_4_member_0_id  mirror_4_member_0_sts  mirror_4_member_1_id  mirror_4_member_1_sts  mirror_5_id  mirror_5_sts  mirror_5_map  mirror_5_capacity  mirror_5_member_0_id  mirror_5_member_0_sts  mirror_5_member_1_id  mirror_5_member_1_sts  mirror_ok   mirror_degraded  mirror_failed
    echo '<engine_cli_mirror>';
    $i = 0;
    while ($row = $results->fetchArray()) {
        // echo "$i";
        echo "<record>";
        $i = $i + 1;
        
        //var_dump($row);
        //echo $row->vmirror_name;
        //print_r($row['vmirror_name']);
        $serial = $row['serial'];
        $seconds = $row['seconds'];
        
        $mirror_0_id = $row['mirror_0_id'];
        $mirror_0_sts = $row['mirror_0_sts'];
        $mirror_0_map = $row['mirror_0_map'];
        
        $mirror_0_capacity = $row['mirror_0_capacity'];
        $mirror_0_member_0_id = $row['mirror_0_member_0_id'];
        $mirror_0_member_0_sts = $row['mirror_0_member_0_sts'];
        $mirror_0_member_1_id = $row['mirror_0_member_1_id'];
        $mirror_0_member_1_sts = $row['mirror_0_member_1_sts'];
        
        $mirror_1_id = $row['mirror_1_id'];
        $mirror_1_sts = $row['mirror_1_sts'];
        $mirror_1_map = $row['mirror_1_map'];
        
        $mirror_1_member_0_id = $row['mirror_1_member_0_id'];
        $mirror_1_member_0_sts = $row['mirror_1_member_0_sts'];
        $mirror_1_member_1_id = $row['mirror_1_member_1_id'];
        $mirror_1_member_1_sts = $row['mirror_1_member_1_sts'];

        $mirror_2_id = $row['mirror_2_id'];
        $mirror_2_sts = $row['mirror_2_sts'];
        $mirror_2_map = $row['mirror_2_map'];
        
        $mirror_2_member_0_id = $row['mirror_2_member_0_id'];
        $mirror_2_member_0_sts = $row['mirror_2_member_0_sts'];
        $mirror_2_member_1_id = $row['mirror_2_member_1_id'];
        $mirror_2_member_1_sts = $row['mirror_2_member_1_sts'];

        $mirror_3_id = $row['mirror_3_id'];
        $mirror_3_sts = $row['mirror_3_sts'];
        $mirror_3_map = $row['mirror_3_map'];
        
        $mirror_3_member_0_id = $row['mirror_3_member_0_id'];
        $mirror_3_member_0_sts = $row['mirror_3_member_0_sts'];
        $mirror_3_member_1_id = $row['mirror_3_member_1_id'];
        $mirror_3_member_1_sts = $row['mirror_3_member_1_sts'];
        
        $mirror_4_id = $row['mirror_4_id'];
        $mirror_4_sts = $row['mirror_4_sts'];
        $mirror_4_map = $row['mirror_4_map'];

        $mirror_4_member_0_id = $row['mirror_4_member_0_id'];
        $mirror_4_member_0_sts = $row['mirror_4_member_0_sts'];
        $mirror_4_member_1_id = $row['mirror_4_member_1_id'];
        $mirror_4_member_1_sts = $row['mirror_4_member_1_sts'];

        $mirror_5_id = $row['mirror_5_id'];
        $mirror_5_sts = $row['mirror_5_sts'];
        $mirror_5_map = $row['mirror_5_map'];

        $mirror_5_member_0_id = $row['mirror_5_member_0_id'];
        $mirror_5_member_0_sts = $row['mirror_5_member_0_sts'];
        $mirror_5_member_1_id = $row['mirror_5_member_1_id'];
        $mirror_5_member_1_sts = $row['mirror_5_member_1_sts'];
        
        $mirror_ok = $row['mirror_ok'];
        $mirror_degraded = $row['mirror_degraded'];
        $mirror_failed = $row['mirror_failed'];

        //echo "[$ha]";
        
        echo "<serial>$serial</serial>";
        echo "<seconds>$seconds</seconds>";
        
        // mirror 0
        echo "<mirror_0_id>$mirror_0_id</mirror_0_id>";
        echo "<mirror_0_sts>$mirror_0_sts</mirror_0_sts>";
        echo "<mirror_0_map>$mirror_0_map</mirror_0_map>";
        echo "<mirror_0_capacity>$mirror_0_capacity</mirror_0_capacity>";
        
        echo "<mirror_0_member_0_id>$mirror_0_member_0_id</mirror_0_member_0_id>";
        echo "<mirror_0_member_0_sts>$mirror_0_member_0_sts</mirror_0_member_0_sts>";
        echo "<mirror_0_member_1_id>$mirror_0_member_1_id</mirror_0_member_1_id>";
        echo "<mirror_0_member_1_sts>$mirror_0_member_1_sts</mirror_0_member_1_sts>";

        // mirror 1
        echo "<mirror_1_id>$mirror_1_id</mirror_1_id>";
        echo "<mirror_1_sts>$mirror_1_sts</mirror_1_sts>";
        echo "<mirror_1_map>$mirror_1_map</mirror_1_map>";
        echo "<mirror_1_capacity>$mirror_1_capacity</mirror_1_capacity>";
        
        echo "<mirror_1_member_0_id>$mirror_1_member_0_id</mirror_1_member_0_id>";
        echo "<mirror_1_member_0_sts>$mirror_1_member_0_sts</mirror_1_member_0_sts>";
        echo "<mirror_1_member_1_id>$mirror_1_member_1_id</mirror_1_member_1_id>";
        echo "<mirror_1_member_1_sts>$mirror_1_member_1_sts</mirror_1_member_1_sts>";

        // mirror 2
        echo "<mirror_2_id>$mirror_2_id</mirror_2_id>";
        echo "<mirror_2_sts>$mirror_2_sts</mirror_2_sts>";
        echo "<mirror_2_map>$mirror_2_map</mirror_2_map>";
        echo "<mirror_2_capacity>$mirror_2_capacity</mirror_2_capacity>";
        
        echo "<mirror_2_member_0_id>$mirror_2_member_0_id</mirror_2_member_0_id>";
        echo "<mirror_2_member_0_sts>$mirror_2_member_0_sts</mirror_2_member_0_sts>";
        echo "<mirror_2_member_1_id>$mirror_2_member_1_id</mirror_2_member_1_id>";
        echo "<mirror_2_member_1_sts>$mirror_2_member_1_sts</mirror_2_member_1_sts>";
        
        // mirror 3
        echo "<mirror_3_id>$mirror_3_id</mirror_3_id>";
        echo "<mirror_3_sts>$mirror_3_sts</mirror_3_sts>";
        echo "<mirror_3_map>$mirror_3_map</mirror_3_map>";
        echo "<mirror_3_capacity>$mirror_3_capacity</mirror_3_capacity>";
        
        echo "<mirror_3_member_0_id>$mirror_3_member_0_id</mirror_3_member_0_id>";
        echo "<mirror_3_member_0_sts>$mirror_3_member_0_sts</mirror_3_member_0_sts>";
        echo "<mirror_3_member_1_id>$mirror_3_member_1_id</mirror_3_member_1_id>";
        echo "<mirror_3_member_1_sts>$mirror_3_member_1_sts</mirror_3_member_1_sts>";
        
        // mirror 4
        echo "<mirror_4_id>$mirror_4_id</mirror_4_id>";
        echo "<mirror_4_sts>$mirror_4_sts</mirror_4_sts>";
        echo "<mirror_4_map>$mirror_4_map</mirror_4_map>";
        echo "<mirror_4_capacity>$mirror_4_capacity</mirror_4_capacity>";
        
        echo "<mirror_4_member_0_id>$mirror_4_member_0_id</mirror_4_member_0_id>";
        echo "<mirror_4_member_0_sts>$mirror_4_member_0_sts</mirror_4_member_0_sts>";
        echo "<mirror_4_member_1_id>$mirror_4_member_1_id</mirror_4_member_1_id>";
        echo "<mirror_4_member_1_sts>$mirror_4_member_1_sts</mirror_4_member_1_sts>";

        // mirror 5
        echo "<mirror_5_id>$mirror_5_id</mirror_5_id>";
        echo "<mirror_5_sts>$mirror_5_sts</mirror_5_sts>";
        echo "<mirror_5_map>$mirror_5_map</mirror_5_map>";
        echo "<mirror_5_capacity>$mirror_5_capacity</mirror_5_capacity>";
        
        echo "<mirror_5_member_0_id>$mirror_5_member_0_id</mirror_5_member_0_id>";
        echo "<mirror_5_member_0_sts>$mirror_5_member_0_sts</mirror_5_member_0_sts>";
        echo "<mirror_5_member_1_id>$mirror_5_member_1_id</mirror_5_member_1_id>";
        echo "<mirror_5_member_1_sts>$mirror_5_member_1_sts</mirror_5_member_1_sts>";
        
        echo "<mirror_ok>$mirror_ok</mirror_ok>";
        echo "<mirror_degraded>$mirror_degraded</mirror_degraded>";
        echo "<mirror_failed>$mirror_failed</mirror_failed>";
        
        
        echo "</record>";
        #echo "<br/>";
    }
    echo '</engine_cli_mirror>';


?>