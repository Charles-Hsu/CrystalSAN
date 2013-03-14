<?php
    
#  get_engine_cli_conmgr_initiator_status_detail.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $db = new SQLite3('server.db');
    $serial = $_GET['serial'];
    
    $results = $db->query("SELECT * FROM engine_cli_conmgr_initiator_status_detail WHERE serial='$serial'");
    // serial      seconds     initiator_id  port        wwpn                status
    
    echo '<engine_cli_conmgr_initiator_status_detail>';
    $i = 0;
    while ($row = $results->fetchArray()) {
        // echo "$i";
        echo "<record>";
        $i = $i + 1;
        
        $serial = $row['serial'];
        $seconds = $row['seconds'];
        
        $initiator_id = $row['initiator_id'];
        $port = $row['port'];
        $wwpn = $row['wwpn'];
        $status = $row['status'];
        
        echo "<serial>$serial</serial>";
        echo "<seconds>$seconds</seconds>";
        
        echo "<initiator_id>$initiator_id</initiator_id>";
        echo "<port>$port</port>";
        echo "<wwpn>$wwpn</wwpn>";
        echo "<status>$status</status>";
                
        echo "</record>";
        #echo "<br/>";
    }
    echo '</engine_cli_conmgr_initiator_status_detail>';


?>