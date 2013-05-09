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
                $table_name = "engine_cli_conmgr_initiator_status_detail";
                $sql = "SELECT * FROM $table_name";
                //echo $sql;
                /*
                 select * from engine_cli_conmgr_drive_status_detail;
                 serial      seconds     id          status      path_0_id   path_0_port  path_0_wwpn         path_0_lun  path_0_pstatus  path_1_id   path_1_port  path_1_wwpn  path_1_lun  path_1_pstatus
                 ----------  ----------  ----------  ----------  ----------  -----------  ------------------  ----------  --------------  ----------  -----------  -----------  ----------  --------------
                 11340292    1367391044  0           A           1           B2           5006-022ad0-485000  0000        A
                 11340292    1367391044  1           A           1           B2           5006-022ad0-485000  0001        A
                 
                 */
                if(isset($serial) && !empty($serial)) {
                    $sql .= " WHERE serial=$serial";
                    if(isset($seconds) && !empty($seconds)) {
                        $sql .= " AND seconds > $seconds";
                    }
                }
                
                $results = $db->query($sql)->fetchAll();
                
                echo "<$table_name>";
                if (is_array($results)) {
                    foreach($results as $key => $row) {
                        $array_key = array_keys($row);
                        $array_value = array_values($row);
                        echo "<record>";
                        for($i=0; $i<count($row); $i+=2) {
                            echo "<$array_key[$i]>$array_value[$i]</$array_key[$i]>";
                        }
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