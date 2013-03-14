<?php
    
#  get_engine_cli_vpd_all.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $db = new SQLite3('server.db');
    $serial = $_GET['serial'];
    
    #$results = $db->query('SELECT site_name,ha_appliance_name,engine00,engine01,engine02,engine03,engine04 FROM ha_cluster');
    $results = $db->query("SELECT * FROM engine_cli_vpd WHERE serial='$serial'");
    /*
     CREATE TABLE engine_cli_vpd (serial text primary key, seconds integer, site_name text, engine_name text, product_type text, fw_version text, fw_data text, redboot text, uid text, pcb text, mac text, ip text, uptime text, alert text, time text, a1_wwpn, a2_wwpn, b1_wwpn, b2_wwpn);
     */
    echo '<engine_cli_vpd>';
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
        $site_name = $row['site_name'];
        $engine_name = $row['engine_name'];
        $product_type = $row['product_type'];
        $fw_version = $row['fw_version'];
        $fw_data = $row['fw_data'];
        $redboot = $row['redboot'];
        $uid = $row['uid'];
        $pcb = $row['pcb'];
        $mac = $row['mac'];
        $ip = $row['ip'];
        $uptime = $row['uptime'];
        $alert = $row['alert'];
        $time = $row['time'];
        $a1_wwpn = $row['a1_wwpn'];
        $a2_wwpn = $row['a2_wwpn'];
        $b1_wwpn = $row['b1_wwpn'];
        $b2_wwpn = $row['b2_wwpn'];
        
        //echo "[$ha]";
        
        echo "<serial>$serial</serial>";
        echo "<seconds>$seconds</seconds>";
        echo "<site_name>$site_name</site_name>";
        echo "<engine_name>$engine_name</engine_name>";
        echo "<product_type>$product_type</product_type>";
        echo "<fw_version>$fw_version</fw_version>";
        echo "<fw_data>$fw_data</fw_data>";
        echo "<redboot>$redboot</redboot>";
        echo "<uid>$uid</uid>";
        echo "<pcb>$pcb</pcb>";
        echo "<mac>$mac</mac>";
        echo "<ip>$ip</ip>";
        echo "<uptime>$uptime</uptime>";
        echo "<alert>$alert</alert>";
        echo "<time>$time</time>";
        echo "<a1_wwpn>$a1_wwpn</a1_wwpn>";
        echo "<a2_wwpn>$a2_wwpn</a2_wwpn>";
        echo "<b1_wwpn>$b1_wwpn</b1_wwpn>";
        echo "<b2_wwpn>$b2_wwpn</b2_wwpn>";
        
        
        echo "</record>";
        #echo '<br>';
    }
    echo '</engine_cli_vpd>';


?>