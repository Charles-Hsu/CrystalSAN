<?php
    
#  http-get-appliance_connection_all_info.php
#
#  http-get-appliance_connection_all_info.php?site=Accusys&serial=11340292
#    CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $site_name = @$_GET['site'] ;
    $serial    = @$_GET['serial'];
    
    function table2XML($db,$table_name,$serial) {
        
        $xml = "";
        $xml .= "<table name='$table_name'>";
        
        $sql = "SELECT * FROM $table_name";
        if(isset($serial) && !empty($serial)) {
            $sql .= " WHERE serial=$serial";
            //if(isset($seconds) && !empty($seconds)) {
            //    $sql .= " AND seconds > $seconds";
            //}
        }
        $results = $db->query($sql)->fetchAll();
        //var_dump($results);
        if (is_array($results)) {
            foreach($results as $key => $row) {
                $array_key = array_keys($row);
                $array_value = array_values($row);
                $xml .= "<record>";
                for($i=0; $i<count($row); $i+=2) {
                    $xml .= "<$array_key[$i]>$array_value[$i]</$array_key[$i]>";
                }
                $xml .= "</record>";
            }
        }
        $xml .= "</table>";
        return $xml;
    }


    try {
        if (isset($site_name) && !empty($site_name)) { //  && isset($serial) && !empty($serial))
            
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                //echo $database;
                $db = new PDO("sqlite:" . $database);
                $xml = "";
                $xml .= "<tables>";
                $xml .= table2XML($db,"engine_cli_conmgr_drive_status",$serial);
                $xml .= table2XML($db,"engine_cli_conmgr_drive_status_detail",$serial);
                $xml .= table2XML($db,"engine_cli_conmgr_drive_status_detail",$serial);
                $xml .= table2XML($db,"engine_cli_dmeprop",$serial);
                $xml .= table2XML($db,"engine_cli_mirror",$serial);
                $xml .= table2XML($db,"engine_cli_vpd",$serial);
                $xml .=  "</tables>";
                echo $xml;

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