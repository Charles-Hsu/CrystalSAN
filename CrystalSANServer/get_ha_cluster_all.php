<?php
    
#  get_ha_cluster_all.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $db = new SQLite3('server.db');
    $site_name = $_GET['site_name'];
    
    #$results = $db->query('SELECT site_name,ha_appliance_name,engine00,engine01,engine02,engine03,engine04 FROM ha_cluster');
    $results = $db->query("SELECT * FROM ha_cluster WHERE site_name='$site_name'");
    echo '<ha_cluster>';
    $i = 0;
    while ($row = $results->fetchArray()) {
        // echo "$i";
        echo "<record>";
        $i = $i + 1;
        
        //var_dump($row);
        //echo $row->vmirror_name;
        //print_r($row['vmirror_name']);
        $site_name = $row['site_name'];
        $engine00 = $row['engine00'];
        $engine01 = $row['engine01'];
        $engine02 = $row['engine02'];
        $engine03 = $row['engine03'];
        $engine04 = $row['engine04'];

        $ha_appliance_name = $row['ha_appliance_name'];
        
        //echo "[$ha]";
        
        echo "<site_name>$site_name</site_name>";
        echo "<ha_appliance_name>$ha_appliance_name</ha_appliance_name>";
        echo "<engine00>$engine00</engine00>";
        echo "<engine01>$engine01</engine01>";
        echo "<engine02>$engine02</engine02>";
        echo "<engine03>$engine03</engine03>";
        echo "<engine04>$engine04</engine04>";
        
        
        echo "</record>";
        #echo '<br>';
    }
    echo '</ha_cluster>';


?>