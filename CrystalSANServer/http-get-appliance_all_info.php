<?php
    
#  http-get-appliance_connection_all_info.php
#
#  http-get-appliance_all_info.php?site=Accusys&serial=11340292&part=1
#
#  part=1 for connection information
#  part=2 for initiator information
#  
#    CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

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
                    if (strlen($array_value[$i])) {
                        $xml .= "<$array_key[$i]>$array_value[$i]</$array_key[$i]>";
                    }
                }
                $xml .= "</record>";
            }
        }
        $xml .= "</table>";
        return $xml;
    }
    
    
    $site_name = @$_GET['site'] ;
    $ha_name   = @$_GET['ha_name'];
    $part      = @$_GET['part'];
    
    try {
        if (isset($site_name) && !empty($site_name)
            && isset($ha_name) && !empty($ha_name)) { //  && isset($serial) && !empty($serial))
            
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                //echo $database;
                $db = new PDO("sqlite:" . $database);
                $xml = "";
                $xml .= "<tables>";
                
                $delimiter = "-";
                $engineList = explode($delimiter, $ha_name);

                foreach ($engineList as $key => $serial) {
                    if ($part==1) {
                        $xml .= table2XML($db,"engine_cli_conmgr_drive_status",$serial);
                        $xml .= table2XML($db,"engine_cli_conmgr_drive_status_detail",$serial);
                        $xml .= table2XML($db,"engine_cli_dmeprop",$serial);
                        $xml .= table2XML($db,"engine_cli_mirror",$serial);
                        $xml .= table2XML($db,"engine_cli_vpd",$serial);
                    } else if ($part==2) {
                        $xml .= table2XML($db,"engine_cli_conmgr_initiator_status",$serial);
                        $xml .= table2XML($db,"engine_cli_conmgr_initiator_status_detail",$serial);
                    }
                }
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