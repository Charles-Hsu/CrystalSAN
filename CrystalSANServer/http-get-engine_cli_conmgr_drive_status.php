<?php
    
#  http-get-engine_cli_conmgr_drive_status.php
#
#  http-get-engine_cli_conmgr_drive_status.php?site=Accusys&serial=11340292
#    CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $site_name = @$_GET['site'] ;
    $serial    = @$_GET['serial'];
    $seconds   = @$_GET['seconds'];
    
    try {
        if (isset($site_name) && !empty($site_name)) { //  && isset($serial) && !empty($serial))
            
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                //echo $database;
                $db = new PDO("sqlite:" . $database);
                $table_name = "engine_cli_conmgr_drive_status";
                
                $sql = "SELECT * FROM $table_name";
                //echo $sql;
                /*
                 sqlite> SELECT * FROM engine_cli_conmgr_drive_status;
                 serial      seconds     inactive    offline_path
                 ----------  ----------  ----------  ------------
                 11340292    1367391044  0           0
                 11340426    1367391044  0           0           

                 */
                if(isset($serial) && !empty($serial)) {
                    $sql .= " WHERE serial=$serial";
                    if(isset($seconds) && !empty($seconds)) {
                        $sql .= " AND seconds > $seconds";
                    }
                }
                
                $results = $db->query($sql)->fetchAll();
                //var_dump ($results);
                
                echo "<$table_name>";
                
                if (is_array($results)) {
                    foreach($results as $key => $row) {
                        $serial = $row['serial'];
                        $seconds = $row['seconds'];
                        $inactive = $row['inactive'];
                        $offline_path = $row['offline_path'];
                        
                        echo "<record>";
                        
                        echo "<serial>$serial</serial>";
                        echo "<seconds>$seconds</seconds>";
                        echo "<inactive>$inactive</inactive>";
                        echo "<offline_path>$offline_path</offline_path>";
                        
                        echo "</record>";
                    }
                }
                 
                echo "</$table_name>";
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