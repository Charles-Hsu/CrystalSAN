<?php
    
#  get_engine_cli_conmgr_initiator_status.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $db = new SQLite3('server.db');
    $serial = $_GET['serial'];

    $results = $db->query("SELECT * FROM engine_cli_conmgr_initiator_status WHERE serial='$serial'");
    // serial      seconds     initiator_id  port        wwpn                status
    
    echo '<engine_cli_conmgr_initiator_status>';
    $i = 0;
    while ($row = $results->fetchArray()) {
        // echo "$i";
        echo "<record>";
        $i = $i + 1;
        
        $serial = $row['serial'];
        $seconds = $row['seconds'];
        
        $online = $row['online'];
        $offline = $row['offline'];
        
        echo "<serial>$serial</serial>";
        echo "<seconds>$seconds</seconds>";
        
        echo "<online>$online</online>";
        echo "<offline>$offline</offline>";
                
        echo "</record>";
        #echo "<br/>";
    }
    echo '</engine_cli_conmgr_initiator_status>';


?>