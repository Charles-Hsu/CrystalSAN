<?php
    
#  get_engine_cli_vpd_all.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $site_name = @$_GET['site'] ;
    $serial    = @$_GET['serial'];
    $seconds   = @$_GET['seconds'];
    
    try {
        if (isset($site_name) && !empty($site_name) && isset($serial) && !empty($serial)) {
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                //echo $database;
                $db = new PDO("sqlite:" . $database);
                $table_name = "engine_cli_vpd";
                
                $sql = "SELECT * FROM $table_name WHERE serial='$serial'";
                
                if(isset($seconds) && !empty($seconds)) {
                    $sql .= " AND seconds > $seconds";
                }
                
                //echo $sql;
                
                $results = $db->query($sql)->fetchAll();
                //var_dump ($results);
                
                echo "<engine_cli_vpd>";
                
                if (is_array($results)) {
                    foreach($results as $key => $row) {
                        $serial = $row['serial'];
                        $seconds = $row['seconds'];
                        $site_name = $row['site_name'];
                        $engine_name = $row['engine_name'];
                        $product_type = $row['product_type'];
                        $fw_version = $row['fw_version'];
                        $fw_date = $row['fw_date'];
                        $redboot = $row['redboot'];
                        $uid = $row['uid'];
                        $pcb = $row['pcb'];
                        $mac = $row['mac'];
                        $ip = $row['ip'];
                        $uptime = $row['uptime'];
                        $alert = $row['alert'];
                        $time = $row['time'];
                        
                        $a1_wwnn = $row['a1_wwnn'];
                        $a2_wwnn = $row['a2_wwnn'];
                        $b1_wwnn = $row['b1_wwnn'];
                        $b2_wwnn = $row['b2_wwnn'];
                        
                        $a1_wwpn = $row['a1_wwpn'];
                        $a2_wwpn = $row['a2_wwpn'];
                        $b1_wwpn = $row['b1_wwpn'];
                        $b2_wwpn = $row['b2_wwpn'];
                        
                        echo "<record>";
                        
                        echo "<serial>$serial</serial>";
                        echo "<seconds>$seconds</seconds>";
                        echo "<site_name>$site_name</site_name>";
                        echo "<engine_name>$engine_name</engine_name>";
                        echo "<product_type>$product_type</product_type>";
                        echo "<fw_version>$fw_version</fw_version>";
                        echo "<fw_date>$fw_date</fw_date>";
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
                        echo "<a1_wwnn>$a1_wwnn</a1_wwnn>";
                        echo "<a2_wwnn>$a2_wwnn</a2_wwnn>";
                        echo "<b1_wwnn>$b1_wwnn</b1_wwnn>";
                        echo "<b2_wwnn>$b2_wwnn</b2_wwnn>";
                        
                        echo "</record>";
                    }
                }
                 
                echo "</engine_cli_vpd>";
            }
            
            
        }
        
        $db = null; // Close file db connection
        
    } catch(PDOException $e) {
        echo $e->getMessage();
        echo "<br><br>SQL=$sql";
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }


?>