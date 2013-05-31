<?php
    
#  http-get-engine_cli_conmgr_drive_status.php
#
#  http-get-engine_cli_conmgr_drive_status.php?site=Accusys&serial=11340292
#    CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $site_name = @$_GET['site'] ;
    //$serial    = @$_GET['serial'];
    $seconds   = @$_GET['seconds'];
    
    try {
        if (isset($site_name) && !empty($site_name)) { //  && isset($serial) && !empty($serial))
            
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                //echo $database;
                $db = new PDO("sqlite:" . $database);
                $table_name = "wwpn_data";
                $sql = "SELECT * FROM $table_name";
                
                if(isset($seconds) && !empty($seconds)) {
                    $sql .= " WHERE seconds > $seconds";
                }
                //echo "hello";
                //echo $sql;
                $results = $db->query($sql)->fetchAll();
                //var_dump($results);
                
                echo "<$table_name>";
                if (is_array($results)) {
                    //echo "is array";
                    foreach($results as $key => $row) {
                        //var_dump($row);
                        $array_key = array_keys($row);
                        $array_value = array_values($row);
                        echo "<record>";
                        for($i=0; $i<count($row); $i+=2) {
                            if(!empty($array_value[$i])) {
                                echo "<$array_key[$i]>$array_value[$i]</$array_key[$i]>";
                            }
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