<?php
    
#  get_engine_cli_conmgr_drive_status.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $db = new SQLite3('server.db');
    $serial = $_GET['serial'];
    
    $results = $db->query("SELECT * FROM engine_cli_conmgr_drive_status WHERE serial='$serial'");
    // serial      seconds     active      inactive
    
    echo '<engine_cli_conmgr_drive_status>';
    $i = 0;
    while ($row = $results->fetchArray()) {
        // echo "$i";
        echo "<record>";
        $i = $i + 1;
        
        $serial = $row['serial'];
        $seconds = $row['seconds'];
        
        $active = $row['active'];
        $inactive = $row['inactive'];
        
        echo "<serial>$serial</serial>";
        echo "<seconds>$seconds</seconds>";
        
        echo "<active>$active</active>";
        echo "<inactive>$inactive</inactive>";

        echo "</record>";
        #echo "<br/>";
    }
    echo '</engine_cli_conmgr_drive_status>';


?>