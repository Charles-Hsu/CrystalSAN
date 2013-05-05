<?php
    
#  get_engine_cli_conmgr_drive_status_detail.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    
    $serial = $_GET['serial'];
    //$var2 = $_GET['var2'];

    $db = new SQLite3('server.db');
    $results = $db->query("SELECT * FROM engine_cli_conmgr_drive_status_detail WHERE serial='$serial'");
    // serial      seconds     drive_id    drive_status
    // path_0_id   path_0_port  path_0_wwpn  path_0_lun  path_0_pstatus
    // path_1_id   path_1_port  path_1_wwpn  path_1_lun  path_1_pstatus
    
    
    echo '<engine_cli_conmgr_drive_status_detail>';
    $i = 0;
    while ($row = $results->fetchArray()) {
        // echo "$i";
        echo "<record>";
        $i = $i + 1;
        
        //$serial = $row['serial'];
        $seconds = $row['seconds'];
        
        $drive_id = $row['drive_id'];
        $drive_status = $row['drive_status'];
        
        $path_0_id = $row['path_0_id'];
        $path_0_port = $row['path_0_port'];
        $path_0_wwpn = $row['path_0_wwpn'];
        $path_0_lun = $row['path_0_lun'];
        $path_0_pstatus = $row['path_0_pstatus'];

        $path_1_id = $row['path_1_id'];
        $path_1_port = $row['path_1_port'];
        $path_1_wwpn = $row['path_1_wwpn'];
        $path_1_lun = $row['path_1_lun'];
        $path_1_pstatus = $row['path_1_pstatus'];

        echo "<serial>$serial</serial>";
        echo "<seconds>$seconds</seconds>";
        
        echo "<drive_id>$drive_id</drive_id>";
        echo "<drive_status>$drive_status</drive_status>";
        
        echo "<path_0_id>$path_0_id</path_0_id>";
        echo "<path_0_port>$path_0_port</path_0_port>";
        echo "<path_0_wwpn>$path_0_wwpn</path_0_wwpn>";
        echo "<path_0_lun>$path_0_lun</path_0_lun>";
        echo "<path_0_pstatus>$path_0_pstatus</path_0_pstatus>";
        
        echo "<path_1_id>$path_1_id</path_1_id>";
        echo "<path_1_port>$path_1_port</path_1_port>";
        echo "<path_1_wwpn>$path_1_wwpn</path_1_wwpn>";
        echo "<path_1_lun>$path_1_lun</path_1_lun>";
        
        echo "<path_1_status/>";
        echo "<path_1_pstatus>$path_1_pstatus</path_1_pstatus>";

        echo "</record>";
        #echo "<br/>";
    }
    echo '</engine_cli_conmgr_drive_status_detail>';


?>