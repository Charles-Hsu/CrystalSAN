<?php
    
    
    function parse_engine_all($file,$db,$site_name) {
        
        $xml = simplexml_load_file($file);
        $result = simpleXMLToArray($xml);
        
        $site = $result['site'];
        
        $engines = $site['engines'];
        $engine = $engines['engine'];
        $engine_name = $engine['name'];
        
        $vpd_info = cli_vpd($site_name, $engine_name, $engine['cli_vpd'], $db);
        
        $serial = $vpd_info['serial'];
        $wwnn = $vpd_info['wwnn'];
        
        cli_mirror($site_name, $engine_name, $serial, $engine['cli_mirror'], $db);
        cli_conmgr_drive_status($site_name, $engine_name, $serial, $engine['cli_conmgr_drive_status'], $db);
        cli_conmgr_engine_status($site_name,$engine_name, $serial, $engine['cli_conmgr_engine_status'], $db);
        
        echo "<br>[cli_conmgr_initiator_status]<br>";
        var_dump ($engine['cli_conmgr_initiator_status']);
        echo "<br>[cli_conmgr_initiator_status]<br>";
        
        cli_conmgr_initiator_status($site_name, $engine_name, $serial, $engine['cli_conmgr_initiator_status'], $db);
        cli_dmeprop($site_name, $engine_name, $serial, $engine['cli_dmeprop'], $db);
        
        ha_appliance_parsing ($db, $site_name, $serial);

    }
    
    function parse_engine_new($file,$db,$site_name) {
        $xml = simplexml_load_file($file);
        $result = simpleXMLToArray($xml);
        
        $site = $result['site'];
        
        $engines = $site['engines'];
        $engine_data = $engines['engine'];
        
        foreach($engine_data as $key => $engine) {
            $engine_name=$engine['name'];
            echo "<br>=====[$engine_name]=========<br>";
            //$engine_cli_vpd = $engine['cli_vpd'];
            //$engine_cli_conmgr_initiator_status = $engine['cli_conmgr_initiator_status'];
            
            if(array_key_exists('cli_vpd', $engine)) {
                new_cli_vpd($site_name, $engine_name, $engine['cli_vpd'], $db);
            }
            
            if(array_key_exists('cli_conmgr_initiator_status', $engine)) {
                new_cli_conmgr_initiator_status($site_name, $engine_name, $engine['cli_conmgr_initiator_status'], $db);
            }
            //var_dump($engine);
        }
        
    }
    
 
    function parse_engine_time($file_name,$db,$site_name) {

        $sql = "CREATE TABLE IF NOT EXISTS engine_time (site_name, engine_name, all_time INTEGER, new_time INTEGER, conn_lost INTEGER)";
        
        $db->exec($sql);
        $xml = simplexml_load_file($file_name);
        //echo "--->$xml";

        //$file = fopen($file_name, "r") or exit("Unable to open file!");
        //Output a line of the file until the end is reached
        //while(!feof($file))
        //{
        //    echo fgets($file). "<br>";
        //}
        //fclose($file);
        
        $result = simpleXMLToArray($xml);
        //var_dump ($result);
        //return;
        $site = $result['site'];
        $engines = $site['engines'];
        $engine_data = $engines['engine'];
        
        foreach($engine_data as $key => $engine) {
            $engine_name=$engine['name'];
            echo "<br>=====[$engine_name]=========<br>";
            
            $conn_lost = $engine['conn_lost'];
            $all_time = $engine['all_time'];
            //var_dump($all_time);
            
            $new_time = $engine['new_time'];
            //var_dump($new_time);
            
            $sql = "DELETE FROM engine_time WHERE engine_name='$engine_name'";
            $db->exec($sql);
            
            $sql = "INSERT INTO engine_time VALUES ('$site_name','$engine_name', $all_time[0], $new_time[0], $conn_lost)";
            //echo $sql;
            $db->exec($sql);
            
        }
        
    }

    function company_by_oui ($oui) {
        
        switch (strtoupper($oui)) {
            case "006022": return "VICOM SYSTEMS, INC.";
            case "000612": return "Accusys, Inc.";
            case "000155": return "Promise Technology, Inc.";
            case "00D023": return "INFORTREND TECHNOLOGY, INC.";
            case "000393": return "Apple Computer, Inc.";
            case "00062B": return "INTRASERVER TECHNOLOGY";
            case "0000C9": return "Emulex Corporation";
            case "001B32": return "QLogic Corporation";
            case "001438": return "Hewlett-Packard Company";
            case "00E08B": return "QLogic Corp.";
        }
        return "";
        
    }
    
    function get_oui_by_wwpn ($wwpn) {
        
        $wwpn = str_replace("-", "", $wwpn);
        
        //echo "wwpn=" . $wwpn;
        
        $oui = "";
        $serial = "";
        $port = "";
        $naa = substr($wwpn,0,1);
        
        switch ($naa) {
            case "1":
            case "2":
                // string substr ( string $string , int $start [, int $length ] )
                $oui = substr($wwpn,4,6);
                $serial = substr($wwpn,10);
                //echo "OUI= $oui <br>";
                
                //$port = "";
                break;
            case "5":
            case "6":
                $oui = substr($wwpn,1,6);
                
                if ($oui == "006022" || $oui == "000612") { // Vicom, Accusys
                    $serial = substr($wwpn,7,7);
                    $port = substr($wwpn,14);
                } else {
                    $serial = substr($wwpn,7);
                    //$port = substr($wwpn,14);
                }
                
                
                //echo '$port = ' . $port . "<br>";
                break;
        }
        //echo '$port = ' . $port . "<br>";
        $array = array(
                       "oui" => $oui,
                       "serial" => sprintf("%08d", hexdec($serial)),
                       "port" => $port,
                       );
        return $array;
    }
    
    function wwpn_data_parsing ($db, $wwnn, $wwpn, $type, $serial, $product_type, $type, $port, $site_name) {
        
        $sql = "CREATE TABLE IF NOT EXISTS wwpn_data (seconds INTEGER, site_name, wwnn, wwpn PRIMARY KEY, oui, company_name, model, type, serial, port_info)";
        $db->exec($sql);
     
        $wwpn_info = get_oui_by_wwpn ($wwpn);
        
        $oui = $wwpn_info['oui'];
        $serial = $wwpn_info['serial'];
        $company_name = company_by_oui($oui);
        if ($port == "") {
            $port = $wwpn_info['port'];
            //$port = "PORT";
        }
        
        $seconds = round(microtime(true));

        $sql = "INSERT INTO wwpn_data VALUES ($seconds, '$site_name', '$wwnn', '$wwpn', '$oui', '$company_name', '$product_type', '$type', '$serial', '$port')";
        $db->exec($sql);
        //echo "<br> $sql <br>";
        
    }
    
    function ha_appliance_parsing ($db, $site_name, $engine_serial) {
        
        echo "<br>*************" . __FUNCTION__ . "<br>";
        
        echo "is master engine? ";
        echo is_master_engine($engine_serial,$db);
        echo "<br>";
        
        $table_name = "ha_cluster";
        $sql = "CREATE TABLE IF NOT EXISTS " . $table_name .
            "(seconds INTEGER, site_name, ha_appliance_name, engine00 PRIMARY KEY, engine01, engine02, engine03 , engine04)";
        $db->exec($sql);
        
        //$sql = "SELECT b.site_name, a.serial 'SN',a.cluster_id, SUBSTR(a.p0_wwpn,6) p0_wwpn, b.engine_name, SUBSTR(b.a1_wwpn,6) a1_wwpn" .
        //    "FROM engine_cli_conmgr_engine_status a, engine_cli_vpd b " .
        //    "WHERE a.serial=b.serial AND a.cluster_id=2";
        
        //$db->exec("DROP TABLE temp_engine_status");
        //$db->exec("DROP TABLE temp_vpd");
        
        $db->exec ("CREATE TABLE IF NOT EXISTS temp_engine_status (seconds INTEGER, serial INTEGER PRIMARY KEY, p0_wwpn)");
        $db->exec ("CREATE TABLE IF NOT EXISTS temp_vpd (site_name, serial INTEGER PRIMARY KEY, engine_name, a1_wwpn)");
        
        $sql = "SELECT seconds,serial,p0_wwpn FROM engine_cli_conmgr_engine_status WHERE cluster_id='2' OR cluster_id=''";
        echo "<br>sql=$sql<br>";
        $result = $db->query($sql)->fetchAll();
        var_dump($result);
        
        foreach($result as $key => $row) {
            $sql = "INSERT INTO temp_engine_status VALUES ('" . $row['seconds'] . "','" . $row['serial'] . "','" . substr ($row['p0_wwpn'], 5) . "')";
            echo "<br>$sql<br>";
            $db->exec ($sql);
        }
        
        $sql = "SELECT site_name,serial,engine_name,a1_wwpn FROM engine_cli_vpd";
        $result = $db->query($sql)->fetchAll();
        //var_dump ($result);

        foreach($result as $key => $row) {
            $sql = "INSERT INTO temp_vpd VALUES ('" . $row['site_name'] . "','" .
                    $row['serial'] . "','" .
                    $row['engine_name'] . "','" .
                    substr ($row['a1_wwpn'], 5) . "')";
            //echo "key == " . $key . "." . $sql . "<br>";
            $db->exec ($sql);
        }
        //echo "--------------<br>";
        //var_dump($result);
        
        $sql = "SELECT a.seconds seconds, b.site_name, a.serial serial, a.p0_wwpn p0_wwpn, b.engine_name, b.a1_wwpn a1_wwpn " .
                "FROM temp_engine_status a, temp_vpd b " .
                "WHERE a.serial=b.serial";
        echo $sql;
        $result = $db->query($sql);
        //var_dump ($result);
        
        foreach($result as $key => $row) {
            $seconds = $row['seconds'];
            $p0_wwpn = $row['p0_wwpn'];
            //echo "p0_wwpn = $p0_wwpn -> ";
            //$serial = $row['serial'];
            //echo "serial = $serial -> ";
            //$engine00 = $serial;
            $primary_key = $row['serial'];
            
            $engine_array = array ();
            array_push($engine_array, $primary_key);
            
            //$sql = "select serial,engine_name from engine_cli_vpd where substr(a1_wwpn,6)='$substr(a.path_0_wwpn,6)'";
            $sql = "SELECT serial FROM temp_vpd where a1_wwpn='$p0_wwpn'";
            echo "SQL ===>" . $sql . "<br>";
            $result1 = $db->query($sql)->fetchAll();
            
            foreach($result1 as $key => $item) {
                array_push($engine_array, $item[0]);
            }
            echo "engine_array -- begin ---";
            sort($engine_array);
            var_dump ($engine_array);
            
            $ha_appliance_name = "";
            $engine_value_string = "";
            $engine_field_string = "";
            
            for ($i=0; $i<count($engine_array); $i++) {
                $engine_value_string .= ",'" . $engine_array[$i] . "'";
                $engine_field_string .= ",engine0" . ($i+1);
                $ha_appliance_name .= $engine_array[$i] . "-";
            }
            
            echo "[";
            echo $engine_value_string;
            echo "]<br>";
            echo "[";
            echo $engine_field_string;
            echo "]<br>";
            
            $ha_appliance_name = substr($ha_appliance_name, 0, -1);
            
            //site_name, ha_appliance_name, engine00 PRIMARY KEY
            
            $sql = "DELETE FROM " . $table_name . " WHERE engine00='" . $primary_key . "'";
            echo "[[[[[[[[[[[$sql]]]]]]]]]]]]]";
            $db->exec($sql);
            
            locate_ha_cluster($primary_key,$db);
            
            $sql = "INSERT INTO " . $table_name .
                " (seconds,site_name,ha_appliance_name,engine00" . $engine_field_string .
                ") VALUES ($seconds,'$site_name','$ha_appliance_name','$primary_key' $engine_value_string)";
            
            echo $sql;
            $db->exec($sql);
            
            echo "engine_array -- end ---";
            
            //var_dump ($db->query($sql)->fetchAll());
            echo "<br>site_name:$site_name, $primary_key, <br>";
        }
        //var_dump ($result);

        $start = gettimeofday(true);
        $end = gettimeofday(true);
        $total = sprintf("%f", $end-$start); //round(,2);
        
    }

    function locate_ha_cluster($serial,$db) {
        $sql = "SELECT engine00 FROM ha_cluster WHERE engine01='$serial' OR engine02='$serial'    ";
        echo $sql;
        $result=$db->query($sql)->fetchAll();
        echo __FUNCTION__;
        var_dump($result);
        echo "end of " . __FUNCTION__;
    }
    
    function is_master_engine($serial,$db) {
        //$sql = "select * from engine_cli_dmeprop where serial='11340426'";
        $sql = "SELECT * FROM engine_cli_dmeprop WHERE serial='$serial'";
        //echo $sql;
        $result = $db->query($sql)->fetchAll();
        //var_dump($result);
        /*array(1) { [0]=> array(18) {
         ["serial"]=> string(8) "11340426" 
         [0]=> string(8) "11340426" 
         ["seconds"]=> string(10) "1370327855" 
         [1]=> string(10) "1370327855" 
         ["cluster_0_id"]=> string(1) "0" 
         [2]=> string(1) "0" 
         ["cluster_0_status"]=> string(1) "A" 
         [3]=> string(1) "A" 
         ["cluster_0_is_master"]=> string(3) "Yes" 
         [4]=> string(3) "Yes" 
         ["cluster_1_id"]=> string(0) "" 
         [5]=> string(0) "" 
         ["cluster_1_status"]=> string(0) "" 
         [6]=> string(0) "" 
         ["cluster_1_is_master"]=> string(0) "" 
         [7]=> string(0) "" 
         ["my_id"]=> string(1) "0" 
         [8]=> string(1) "0" } }
         */
        //$my_id = $result['my_id'];
        //$cluster_0_id = $result['cluster_0_id'];
        //$cluster_1_id = $result['cluster_1_id'];
        if ($result[0]['my_id'] == $result[0]['cluster_0_id']) {
            return $result[0]['cluster_0_is_master'];
        }
        return $result[0]['cluster_1_is_master'];
    }
    
    /*
     $product_type = $cli_vpd[product_type]; //FCE4400
     $fw_version = $cli_vpd[fw_version]; //15.1.10
     $fw_date = $cli_vpd[fw_date]; // => Sep 17 2012 16:56:07
     $redboot = $cli_vpd[redboot]; // => 0.2.0.6
     $uid = $cli_vpd[uid]; // => 00000060-2209299A
     $serial = $cli_vpd[serial]; // => 00600474
     $pcb = $cli_vpd[pcb]; // => 00600474
     $mac = $cli_vpd[mac]; // => 0.60.22.9.29.9A
     $ip = $cli_vpd[ip]; // => 10.100.5.211
     $uptime = $cli_vpd[uptime]; // => 164d 03:56:09
     $alert = $cli_vpd[alert]; // => None
     $time = $cli_vpd[time]; // => Wednesday 3/20/2013 11:29:00
     $seconds = $cli_vpd[seconds];
     */
    /*
     CREATE TABLE IF NOT EXISTS engine_cli_vpd (serial text primary key, seconds integer, site_name text, engine_name text, product_type text, fw_version text, fw_date text, redboot text, uid text, pcb text, :mac text, ip text, uptime text, alert text, time text, a1_wwnn, a1_wwpn, a2_wwnn, a2_wwpn, b1_wwnn, b1_wwpn, b2_wwnn, b2_wwpn);
     */
    
    function cli_vpd($site_name,$engine_name,$cli_vpd,$db) {
                        
        $table_name = "engine_cli_vpd";
        echo "<br>" . $table_name . "----><br>";
        $sql = "CREATE TABLE IF NOT EXISTS $table_name (serial INTEGER primary key, seconds integer, site_name, engine_name, product_type, fw_version, fw_date, redboot, uid, pcb, mac, ip, uptime, alert, time, a1_wwnn, a1_wwpn, a2_wwnn, a2_wwpn, b1_wwnn, b1_wwpn, b2_wwnn, b2_wwpn)";
        echo $sql;
        
        $db->exec($sql);

        $key_array = array_keys($cli_vpd);
        
        //var_dump($key_array);
        
        
        $value_array = array_values($cli_vpd);
        
        $sql_key_string = "";
        $sql_value_string = "";
                  
        $serial = $cli_vpd['serial'];
        $product_type = $cli_vpd['product_type'];
        $type = "Engine";
        
        echo "DELETE FROM $table_name WHERE serial=$serial<br>";
        $db->exec("DELETE FROM $table_name WHERE serial='$serial'");
        
        for ($i=0; $i<count($key_array); $i++) {
            if ($key_array[$i] != "ports") {
                $sql_key_string .= $key_array[$i];
                $sql_value_string .= "'$value_array[$i]'";
                $sql_key_string .= ",";
                $sql_value_string .= ",";
            }
        }
        
        $port_array = $cli_vpd['ports'];
        var_dump ($port_array);
        
        $wwnn = "";
        
        for ($i=0; $i<count($port_array); $i++) {
            $id = strtolower($port_array[$i]['id']);
            if (count($port_array) == 2) {
                $id .= '1';
            }
            $wwnn = $port_array[$i]['wwnn'];
            $wwpn = $port_array[$i]['wwpn'];
            
            $sql_key_string .= ("$id" . "_wwnn") . ",";
            $sql_value_string .= "'$wwnn'" . ",";
            $sql_key_string .= ("$id" . "_wwpn") . ",";
            $sql_value_string .= "'$wwpn'"  . ",";
            
            //var_dump (get_oui_by_wwpn ($wwpn));
            wwpn_data_parsing ($db, $wwnn, $wwpn, $type, $serial, $product_type, $type, strtoupper($id), $site_name);
            
        }
        
        $sql_key_string .= "site_name,engine_name";
        $sql_value_string .= "'$site_name','$engine_name'";
        
        $sql_stmt = "INSERT INTO engine_cli_vpd ("
                  . $sql_key_string
                  .") VALUES ("
                  . $sql_value_string
                  .")";
        echo $sql_stmt . "<br>";
                  
        $db->exec($sql_stmt);
        
        $array = array(
                       "serial" => $serial,
                       "wwnn" => $wwnn,
                       );
        
                
        
        
        
        return $array;
    }
    
    
    function new_cli_vpd($site_name,$engine_name,$cli_vpd,$db) {
        
        $table_name = "engine_cli_vpd";
        echo "<br>" . __FUNCTION__ . "----><br>";
        
        //sqlite> UPDATE newcontacts SET LastName="Millford" WHERE Email="gpmillford@mymail.fake"; 
        // build query...
        
        $sql = "CREATE TABLE IF NOT EXISTS new_$table_name (serial INTEGER, seconds integer, site_name, engine_name, product_type, fw_version, fw_date, redboot, uid, pcb, mac, ip, uptime, alert, time, a1_wwnn, a1_wwpn, a2_wwnn, a2_wwpn, b1_wwnn, b1_wwpn, b2_wwnn, b2_wwpn)";
        echo $sql . "<br>";
        $db->exec($sql);
        
        $sql = "UPDATE $table_name SET ";
        
        $key_array = array_keys($cli_vpd);
        $value_array = array_values($cli_vpd);
        
        var_dump($key_array);
        var_dump($value_array);
        
        for($i=0; $i<count($key_array); $i++) {
            $sql .= "$key_array[$i]='$value_array[$i]'";
            if($i<count($key_array)-1) {
                $sql .= ",";
            }
        }
        $sql .= " WHERE engine_name='$engine_name'";
        echo $sql;
        $db->exec($sql);
        
        $sql = "INSERT INTO new_$table_name";
        // implode keys of $array...
        $sql .= " (`engine_name`,`".implode("`, `", $key_array)."`)";
        // implode values of $array...
        $sql .= " VALUES ('$engine_name','".implode("', '", $value_array)."') ";
        
        echo $sql;
        $db->exec($sql);

    }
    
    
    function new_cli_conmgr_initiator_status($site_name, $engine_name, $data, $db) {
        echo __FUNCTION__ . "<br>";
        $table_name = "engine_cli_conmgr_initiator_status";
        
        $sql = "SELECT serial FROM engine_cli_vpd WHERE engine_name='$engine_name'";
        $result = $db->query($sql)->fetch();
        $serial = $result['serial'];
        
        $online = $data['online'];
        $offline = $data['offline'];
        $seconds = $data['seconds'];
        
        $sql = "UPDATE $table_name SET online=$online, offline=$offline, seconds=$seconds WHERE serial='$serial'";
        //echo $sql;
        $db->exec($sql);
        
        $table_name = "new_engine_cli_conmgr_initiator_status";
        $sql = "CREATE TABLE IF NOT EXISTS $table_name (serial INTEGER, seconds INTEGER, online INTEGER, offline INTEGER)";
        echo $sql;
        $db->exec($sql);
        $sql = "INSERT INTO $table_name (`online`,`offline`,`seconds`,`serial`) VALUES ($online,$offline,$seconds,$serial)";
        echo $sql;
        $db->exec($sql);
        
        $initiators = $data['initiators'];
        
        $table_name = "engine_cli_conmgr_initiator_status_detail";
        $new_table_name = "new_engine_cli_conmgr_initiator_status_detail";
        $sql = "CREATE TABLE IF NOT EXISTS $new_table_name (serial INTEGER, seconds INTEGER, id, port, wwpn, status);";
        $db->exec($sql);

        foreach ($initiators as $key => $initiator) {
            var_dump($initiator);
            $id = $initiator['id'];
        
            $sql = "UPDATE $table_name SET seconds=$seconds,";
            //$new_sql = "INSERT INTO $new_table_name";
            $new_keys = "";
            $new_values = "";

            $key_array = array_keys($initiator);
            $value_array = array_values($initiator);
            
            //var_dump($key_array);
            //var_dump($value_array);
            
            for($i=0; $i<count($key_array); $i++) {
                $sql .= "$key_array[$i]='$value_array[$i]'";
                $new_keys .= "`$key_array[$i]`";
                $new_values .= "'$value_array[$i]'";
                if($i<count($key_array)-1) {
                    $sql .= ",";
                    $new_keys .= ",";
                    $new_values .= ",";
                }
            }
            $sql .= " WHERE serial=$serial AND id='$id'";
            echo $sql;
            $db->exec($sql);
            
            $sql = "INSERT INTO $new_table_name (`serial`,`seconds`,$new_keys) VALUES ('$serial','$seconds',$new_values)";
            echo $sql;
            $db->exec($sql);
        }
    }
    
    /*
        //if($result) {
        //
        //}
        
        
        $initiators = $data['initiators'];
        for($i=0; $i<count($initiators); $i++) {
            $initiator = $initiators[$i];
            $id = $initiator['id'];
            $status = $initiator['status'];
            $sql = "INSERT INTO $table_name" . "_detail VALUES ('$serial', '$seconds', '$id', '$port', '$wwpn', '$status')";
            $db->exec($sql);
        }
        
    }
    */


?>


<?php
    /*
    
    // array containing data
    $array = array(
                   "name" => "John",
                   "surname" => "Doe",
                   "email" => "j.doe@intelligence.gov"
                   );
    
    // build query...
    $sql  = "INSERT INTO table";
    
    // implode keys of $array...
    $sql .= " (`".implode("`, `", array_keys($array))."`)";
    
    // implode values of $array...
    $sql .= " VALUES ('".implode("', '", $array)."') ";
    
    // execute query...
    $result = mysql_query($sql) or die(mysql_error());
     */
    
?>

<?php
    
    function cli_mirror($site_name,$engine_name,$serial,$data,$db) {
        
        $table_name = "engine_" . __FUNCTION__;
        //echo "<br>" . $table_name . "----><br>";
        
        $sql = "CREATE TABLE IF NOT EXISTS $table_name (serial INTEGER PRIMARY KEY, seconds INTEGER," .
            "m0_id, m0_sts, m0_map, m0_capacity, m0_mb0_id, m0_mb0_sts, m0_mb1_id, m0_mb1_sts," .
            "m1_id, m1_sts, m1_map, m1_capacity, m1_mb0_id, m1_mb0_sts, m1_mb1_id, m1_mb1_sts," .
            "m2_id, m2_sts, m2_map, m2_capacity, m2_mb0_id, m2_mb0_sts, m2_mb1_id, m2_mb1_sts," .
            "m3_id, m3_sts, m3_map, m3_capacity, m3_mb0_id, m3_mb0_sts, m3_mb1_id, m3_mb1_sts," .
            "m4_id, m4_sts, m4_map, m4_capacity, m4_mb0_id, m4_mb0_sts, m4_mb1_id, m4_mb1_sts," .
            "m5_id, m5_sts, m5_map, m5_capacity, m5_mb0_id, m5_mb0_sts, m5_mb1_id, m5_mb1_sts," .
            "ok INTEGER, degraded INTEGER, failed INTEGER)";
        //echo $sql;
        $db->exec($sql);

        // delete the old one
        //echo "DELETE FROM $table_name WHERE serial=$serial<br>";
        $db->exec("DELETE FROM $table_name WHERE serial='$serial'");
        
        // prepare the new insert statement
        $mirror_ok = $data['mirror_ok'];
        $mirror_degraded = $data['mirror_degraded'];
        $mirror_failed = $data['mirror_failed'];
        $seconds = $data['seconds'];
        $mirrors = $data['mirrors'];
        
        $sql_fields = "serial, seconds,";
        $sql_values = "'$serial', '$seconds',";
        
        //echo "<br>mirror count = " . count($mirrors) . "<br>";
        
        for ($i=0; $i<count($mirrors); $i++) {
            $mirror = $mirrors[$i];
            $title = "m" . $i . "_";
            //echo "<br>$i " . var_dump($mirror);
            //echo "<br>" . $title . "id=" . $mirror[id];
            //echo "<br>" . $title . "sts=" . $mirror[status];
            //echo "<br>" . $title . "map=" . $mirror[map];
            //echo "<br>" . $title . "capacity=" . $mirror[capacity];
            //echo "<br>";
            
            $sql_fields .= $title . "id,";
            $sql_fields .= $title . "sts,";
            $sql_fields .= $title . "map,";
            $sql_fields .= $title . "capacity,";
            
            $sql_values .= "'" . $mirror['id'] ."',";
            $sql_values .= "'" . $mirror['status'] ."',";
            $sql_values .= "'" . $mirror['map'] ."',";
            $sql_values .= "'" . $mirror['capacity'] ."',";
            
            $sql_fields .= $title . "mb" . '0' . "_id,";
            $sql_fields .= $title . "mb" . '0' . "_sts,";
            $sql_fields .= $title . "mb" . '1' . "_id,";
            $sql_fields .= $title . "mb" . '1' . "_sts,";
            
            $sql_values .= "'" . $mirror['members'][0]['first'] . "',";
            $sql_values .= "'" . $mirror['members'][0]['status1'] . "',";
            $sql_values .= "'" . $mirror['members'][1]['second'] . "',";
            $sql_values .= "'" . $mirror['members'][1]['status2'] . "',";
            
        }
        
        $sql_fields .= "ok, degraded, failed";
        $sql_values .= "'$mirror_ok', '$mirror_degraded', '$mirror_failed'";

        
        //echo "[" . $sql_fields . "]<br>";
        //echo "[" . $sql_values . "]<br>";
        
        $sql = "INSERT INTO " . $table_name . "(" . $sql_fields . ") VALUES (" . $sql_values . ")";
        //echo $sql;
        //echo "<br>";
        
        $db->exec($sql);

    }

    
    
    function cli_conmgr_drive_status($site_name,$engine_name,$serial,$data,$db) {
        $table_name = "engine_" . __FUNCTION__;
        //echo "<br>" . $table_name . "----><br>";
        //echo "<br>===============================================<br>";
        //var_dump($data);
        //echo "<br>===============================================<br>";
        
        $sql = "CREATE TABLE IF NOT EXISTS $table_name (serial INTEGER PRIMARY KEY, seconds INTEGER, inactive INTEGER, offline_path INTEGER)";
        //echo $sql;
        $db->exec($sql);
        
        //echo "DELETE FROM $table_name WHERE serial=$serial<br>";
        //$db->exec("DELETE FROM $table_name WHERE serial='$serial'");
        
        $sql = "INSERT INTO $table_name(serial,seconds,inactive,offline_path) VALUES($serial,$data[seconds],$data[inactive],$data[offline_path])";
        //echo $sql;
        $db->exec($sql);
        
        $sql = "CREATE TABLE IF NOT EXISTS " . $table_name . "_detail (serial INTEGER, seconds INTEGER, id, status," .
            "path_0_id, path_0_port, path_0_wwpn, path_0_lun, path_0_pstatus," .
            "path_1_id, path_1_port, path_1_wwpn, path_1_lun, path_1_pstatus," .
            "PRIMARY KEY (serial, seconds, id))";
        //echo $sql;
        $db->exec($sql);
        
        $db->exec("DELETE FROM " . $table_name ."_detail WHERE serial='$serial'");
        
        $key_array = array_keys($data);
        $value_array = array_values($data);
        
        $seconds = $data['seconds'];
        $type = "RAID";

        $drives = $data['drives'];
        
        for ($i =0; $i<count($drives); $i++) {
            
            $drive = $drives[$i];
            
            //echo "loop " . $i . "<br>";
            //var_dump ($drives[$i]);
            // serial,seconds,id,status,
            // path_0_id, path_0_port, path_0_wwpn, path_0_lun, path_0_pstatus,path_1_id, path_1_port, path_1_wwpn, path_1_lun, path_1_pstatus,
            $sql_key_string = "serial,seconds,id,status,";
            $sql_value_string = "'$serial','$seconds','$drive[id]','$drive[status]',";

            $paths = $drives[$i]['paths'];
            
            //$j=0;
            $product_type = "";
            $wwnn = "";
            
            
            // check if the array '$paths' has the item 'port', if so then the only one path in that drive
            if (array_key_exists('port', $paths)) {
                $path = $paths;
                $j = 0;
                $sql_key_string .= "path_" . $j . "_id, path_" . $j . "_port, path_" . $j . "_wwpn, path_" . $j . "_lun, path_" . $j . "_pstatus,";
                
                $id = $path['id'];
                $port = $path['port'];
                $wwpn = $path['wwpn'];
                $lun = $path['lun'];
                $pstatus = $path['pstatus'];

                $sql_value_string .= "'$id'," . "'$port'," . "'$wwpn'," . "'$lun'," . "'$pstatus',";
                
                
                wwpn_data_parsing ($db, $wwnn, $wwpn, $type, $serial, $product_type, $type, "", $site_name);
                
                
            } else {
                for ($j=0; $j<count($paths); $j++) {
                    $path = $paths[$j];
                    $sql_key_string .= "path_" . $j . "_id, path_" . $j . "_port, path_" . $j . "_wwpn, path_" . $j . "_lun, path_" . $j . "_pstatus,";
                    // { ["port"]=> string(2) "B2" ["wwpn"]=> string(18) "2601-000155-610d31" ["lun"]=> string(4) "0000" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "2" } }
                    $id = $path['id'];
                    $port = $path['port'];
                    $wwpn = $path['wwpn'];
                    $lun = $path['lun'];
                    $pstatus = $path['pstatus'];
                    $sql_value_string .= "'$id'," . "'$port'," . "'$wwpn'," . "'$lun'," . "'$pstatus',";
                    
                    wwpn_data_parsing ($db, $wwnn, $wwpn, $type, $serial, $product_type, $type, "", $site_name);
                }
            }
            
            //}
            //echo "<br>+++++++++++" . substr($sql_key_string,0,-1) . "++++++++++++++";
            //echo "<br>+++++++++++" . substr($sql_value_string,0,-1) . "++++++++++++++";
            
            $sql = "INSERT INTO " . $table_name ."_detail (" . substr($sql_key_string,0,-1) . ") VALUES (" . substr($sql_value_string,0,-1) . ")";
            //echo "*****SQL*******<br>" . $sql . "<br>******************";
            $db->exec($sql);
            
        }
        
        //echo "<<<<<<<<<end of $table_name>>>>><br>+++++++++++";
        
    }

    /*
     
     one 1 paths
     
    -----clusters---NG
    array(3) { ["id"]=> string(1) "2" ["paths"]=> array(4) { ["port"]=> string(2) "B2" ["wwpn"]=> string(18) "2400-006022-ad0a8a" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "1" } ["status"]=> string(1) "A" } -----clusters---
    
    
    -----clusters---OK
     
     two paths
     
    array(3) { ["id"]=> string(1) "1" ["paths"]=> array(2) { [0]=> array(4) { ["port"]=> string(2) "B1" ["wwpn"]=> string(18) "2300-006022-09298e" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "1" } [1]=> array(4) { ["port"]=> string(2) "B2" ["wwpn"]=> string(18) "2400-006022-09298e" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "2" } } ["status"]=> string(1) "A" } -----clusters---
     */
    
    function cli_conmgr_engine_status($site_name,$engine_name,$serial,$data,$db) {
        
        $table_name = "engine_" . __FUNCTION__;
        //echo "<br>" . $table_name . "----><br>";
        
        $sql = "CREATE TABLE IF NOT EXISTS $table_name (serial INTEGER PRIMARY KEY, seconds INTEGER, cluster_id INTEGER, status, p0_id, p0_port, p0_wwpn, p0_pstatus, p1_id, p1_port, p1_wwpn, p1_pstatus, cluster_not_ok INTEGER, path_not_ok INTEGER)";
        //echo $sql;
        $db->exec($sql);
        echo "------cli_conmgr_engine_status--------<br>";
        var_dump($data);
        echo "------cli_conmgr_engine_status--------<br>";
        $cluster_not_ok = $data['cluster_not_ok'];
        $path_not_ok = $data['path_not_ok'];
        $seconds = $data['seconds'];
        $clusters = $data['clusters'];

        $id = $clusters['id'];
        $status = $clusters['status'];

        $paths = $clusters['paths'];
        
        //$sql_key_string = "serial,seconds,cluster_id,cluster_status,";
        $sql_value_string = "'$serial',$seconds,'$id','$status'";
        echo "-----clusters---<br>";
        var_dump($clusters);
        echo "-----clusters---<br>";
        echo "-----paths---<br>";
        var_dump($paths);
        echo "-----paths---<br>";
        

        if ($paths['id'] != '') { //
            $paths = array(
                           0 => $paths
                           );
        }
        
        
        echo "count of paths = " . count($paths) . "<br>";

        $i=0;
        for(; $i<count($paths); $i++) {
            echo $i . ".";
            
            
            $path = $paths[$i];
            var_dump($path);
            // array(4) { ["port"]=> string(2) "B1" ["wwpn"]=> string(18) "2300-006022-0928f2" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "1" }
            $port = $path['port'];
            $wwpn = $path['wwpn'];
            $pstatus = $path['pstatus'];
            $id = $path['id'];
            
            $sql_value_string .= ",'" . $path['id'] . "'";
            $sql_value_string .= ",'" . $path['port'] . "'";
            $sql_value_string .= ",'" . $path['wwpn'] . "'";
            $sql_value_string .= ",'" . $path['pstatus'] . "'";
            
            echo "$port" . "," . "$wwpn" . "," . "$pstatus" . "," . "$id";
            echo "<br>";
        }
        for(; $i<2; $i++) {
            $sql_value_string .= ",'','','',''";
        }
        $sql_value_string .= "," . $cluster_not_ok;
        $sql_value_string .= "," . $path_not_ok;

        $sql = "INSERT INTO $table_name VALUES(" . $sql_value_string . ")";
        $db->exec($sql);
        echo $sql . "<br>";
                
        //echo $cluster_not_ok . "," . $path_not_ok . "," . $seconds;
        
    }

    function cli_conmgr_initiator_status($site_name, $engine_name, $serial, $data, $db) {
 
        $table_name = "engine_" . __FUNCTION__;
        //echo "<br>" . $table_name . "----><br>";
        
        //var_dump($data);
        /*
         array(4) { ["initiators"]=> array(4) { [0]=> array(4) { ["id"]=> string(1) "0" ["port"]=> string(2) "A1" ["wwpn"]=> string(18) "1000-00062b-1ec31c" ["status"]=> string(1) "I" } [1]=> array(4) { ["id"]=> string(1) "1" ["port"]=> string(2) "A1" ["wwpn"]=> string(18) "1000-00062b-1bc280" ["status"]=> string(1) "A" } [2]=> array(4) { ["id"]=> string(1) "2" ["port"]=> string(2) "A1" ["wwpn"]=> string(18) "1000-00062b-1bbfd8" ["status"]=> string(1) "A" } [3]=> array(4) { ["id"]=> string(1) "3" ["port"]=> string(2) "A1" ["wwpn"]=> string(18) "1000-00062b-1ec4f4" ["status"]=> string(1) "I" } } ["online"]=> string(1) "2" ["offline"]=> string(1) "2" ["seconds"]=> string(10) "1363746627" }
         */
        
        $sql = "CREATE TABLE IF NOT EXISTS $table_name (serial INTEGER PRIMARY KEY, seconds INTEGER, online INTEGER, offline INTEGER)";
        $db->exec($sql);
        
        $sql = "CREATE TABLE IF NOT EXISTS $table_name" . "_detail (serial INTEGER, seconds INTEGER, id, port, wwpn, status, PRIMARY KEY (serial, id))";
        $db->exec($sql);
        
        $online = $data['online'];
        $offline = $data['offline'];
        $seconds = $data['seconds'];
        
        $sql = "DELETE FROM $table_name WHERE serial = '$serial'";
        $db->exec($sql);
        
        $sql = "INSERT INTO $table_name VALUES ('$serial', '$seconds', '$online', '$offline')";
        $db->exec($sql);
        //echo $sql . "<br>";
        
        $sql = "DELETE FROM $table_name" . "_detail WHERE serial = '$serial'";
        $db->exec($sql);
        $type = "HBA";
        $product_type = "";
        $wwnn = "";
        
        if (array_key_exists('initiators', $data)) {
            $initiators = $data['initiators'];
            for($i=0; $i<count($initiators); $i++) {
                $initiator = $initiators[$i];
                $id = $initiator['id'];
                $port = $initiator['port'];
                $wwpn = $initiator['wwpn'];
                $status = $initiator['status'];
                //var_dump ($initiator);
                //echo $id . "," . $port . "," . $wwpn . "," . $status . "<br>";
                //echo "<br>";
                $sql = "INSERT INTO $table_name" . "_detail VALUES ('$serial', '$seconds', '$id', '$port', '$wwpn', '$status')";
                $db->exec($sql);
                
                wwpn_data_parsing ($db, $wwnn, $wwpn, $type, $serial, $product_type, $type, "", $site_name);
                
            }
        }
        
        
        //echo "---------> Done<br>";

        //var_dump($data);
        /*
         set id [lindex [lindex [lindex $idData 2] 0] 1]
         set port [lindex [lindex [lindex $portData 2] 0] 1]
         set wwpn [lindex [lindex [lindex $wwpnData 2] 0] 1]
         set status [lindex [lindex [lindex $statusData 2] 0] 1]
         puts "serial=$serial"
         puts "seconds=$seconds"
         puts "id=$id"
         puts "port=$port"
         puts "wwpn=$wwpn"
         puts "status=$status"
         #puts $id
         #puts [lindex $initiatorData 2]
         set sql "INSERT INTO engine_cli_conmgr_initiator_status_detail VALUES ('$serial', '$seconds', '$id', '$port', '$wwpn', '$status')"

         */
    }
   
    function cli_dmeprop($site_name, $engine_name, $serial, $data, $db) {
        
        $table_name = "engine_" . __FUNCTION__;
        //echo "<br>" . $table_name . "----><br>";
        
        $sql = "CREATE TABLE IF NOT EXISTS $table_name (serial INTEGER PRIMARY KEY, seconds INTEGER, " .
            "cluster_0_id, cluster_0_status, cluster_0_is_master, cluster_1_id, cluster_1_status, cluster_1_is_master, my_id);";
        $db->exec($sql);
        
        echo "-----------------";
        var_dump($data);
        echo "-----------------";
        $my_id = $data['my_id'];

        $clusters = $data['clusters'];
        $seconds = $data['seconds'];
        
        
        $cluster0_id = '';
        $cluster0_status = '';
        $cluster0_is_master = '';
        
        $cluster1_id = '';
        $cluster1_status = '';
        $cluster1_is_master = '';

        if (array_key_exists('id', $clusters)) { // only one engine in clusters
            $cluster0 = $clusters;
            $cluster0_id = $cluster0['id'];
            $cluster0_status = $cluster0['status'];
            $cluster0_is_master = $cluster0['is_master'];
        } else {
            $cluster0 = $clusters[0];
            $cluster0_id = $cluster0['id'];
            $cluster0_status = $cluster0['status'];
            $cluster0_is_master = $cluster0['is_master'];
            
            $cluster1 = $clusters[1];
            $cluster1_id = $cluster1['id'];
            $cluster1_status = $cluster1['status'];
            $cluster1_is_master = $cluster1['is_master'];
        }
        
        $sql = "DELETE FROM $table_name WHERE serial='$serial'";
        $db->exec($sql);
        
        $sql = "INSERT INTO $table_name VALUES ('$serial', '$seconds', '$cluster0_id', '$cluster0_status', '$cluster0_is_master', '$cluster1_id', '$cluster1_status', '$cluster1_is_master', '$my_id')";
        
        echo $sql;
        $db->exec($sql);
        
        
        //echo "---------> Done<br>";
        
        //var_dump($cluster0[id]);
        //var_dump($cluster1[id]);
        //var_dump($my_id);
    }
    

    /*
     cli_conmgr_drive_status($site_name,$engine_name,$engine[cli_conmgr_drive_status],$db);
    cli_conmgr_engine_status($site_name,$engine_name,$engine[cli_conmgr_engine_status],$db);
    cli_conmgr_initiator_status($site_name,$engine_name,$engine[cli_conmgr_initiator_status],$db);
    cli_dmeprop($site_name,$engine_name,$engine[cli_dmeprop],$db);
     
     
     loop 3
     array(3) {
     ["id"]=> string(1) "3"
     ["status"]=> string(1) "A"
     ["paths"]=> array(2) {
     [0]=> array(5) { ["port"]=> string(2) "B1" ["wwpn"]=> string(18) "2602-000155-610d32" ["lun"]=> string(4) "0001" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "1" }
     [1]=> array(5) { ["port"]=> string(2) "B2" ["wwpn"]=> string(18) "2603-000155-610d32" ["lun"]=> string(4) "0001" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "2" } } }
     +++++++++++serial, seconds,id,status,path_0_id, path_0_port, path_0_wwpn, path_0_lun, path_0_pstatus,path_1_id, path_1_port, path_1_wwpn, path_1_lun, path_1_pstatus++++++++++++++
     loop 4
     array(3) {
     ["id"]=> string(1) "4"
     ["status"]=> string(1) "A"
     ["paths"]=> array(5) { ["port"]=> string(2) "B2" ["wwpn"]=> string(18) "6000-393000-01aa0d" ["lun"]=> string(4) "0000" ["pstatus"]=> string(1) "A" ["id"]=> string(1) "1" } }
     +++++++++++serial, seconds,id,status,path_0_id, path_0_port, path_0_wwpn, path_0_lun, path_0_pstatus,path_1_id, path_1_port, path_1_wwpn, path_1_lun, path_1_pstatus,path_2_id, path_2_port, path_2_wwpn, path_2_lun, path_2_pstatus,path_3_id, path_3_port, path_3_wwpn, path_3_lun, path_3_pstatus,path_4_id, path_4_port, path_4_wwpn, path_4_lun, path_4_pstatus++++++++++++++

     */

?>



<?php
    // http://www.php.net/manual/fr/book.simplexml.php#105697
    /**
     * Converts a simpleXML element into an array. Preserves attributes.<br/>
     * You can choose to get your elements either flattened, or stored in a custom
     * index that you define.<br/>
     * For example, for a given element
     * <code>
     * <field name="someName" type="someType"/>
     * </code>
     * <br>
     * if you choose to flatten attributes, you would get:
     * <code>
     * $array['field']['name'] = 'someName';
     * $array['field']['type'] = 'someType';
     * </code>
     * If you choose not to flatten, you get:
     * <code>
     * $array['field']['@attributes']['name'] = 'someName';
     * </code>
     * <br>__________________________________________________________<br>
     * Repeating fields are stored in indexed arrays. so for a markup such as:
     * <code>
     * <parent>
     *     <child>a</child>
     *     <child>b</child>
     *     <child>c</child>
     * ...
     * </code>
     * you array would be:
     * <code>
     * $array['parent']['child'][0] = 'a';
     * $array['parent']['child'][1] = 'b';
     * ...And so on.
     * </code>
     * @param simpleXMLElement    $xml            the XML to convert
     * @param boolean|string    $attributesKey    if you pass TRUE, all values will be
     *                                            stored under an '@attributes' index.
     *                                            Note that you can also pass a string
     *                                            to change the default index.<br/>
     *                                            defaults to null.
     * @param boolean|string    $childrenKey    if you pass TRUE, all values will be
     *                                            stored under an '@children' index.
     *                                            Note that you can also pass a string
     *                                            to change the default index.<br/>
     *                                            defaults to null.
     * @param boolean|string    $valueKey        if you pass TRUE, all values will be
     *                                            stored under an '@values' index. Note
     *                                            that you can also pass a string to
     *                                            change the default index.<br/>
     *                                            defaults to null.
     * @return array the resulting array.
     */
    function simpleXMLToArray(SimpleXMLElement $xml,$attributesKey=null,$childrenKey=null,$valueKey=null){
        
        if($childrenKey && !is_string($childrenKey)){$childrenKey = '@children';}
        if($attributesKey && !is_string($attributesKey)){$attributesKey = '@attributes';}
        if($valueKey && !is_string($valueKey)){$valueKey = '@values';}
        
        $return = array();
        $name = $xml->getName();
        $_value = trim((string)$xml);
        if(!strlen($_value)){$_value = null;};
        
        if($_value!==null){
            if($valueKey){$return[$valueKey] = $_value;}
            else{$return = $_value;}
        }
        
        $children = array();
        $first = true;
        foreach($xml->children() as $elementName => $child){
            $value = simpleXMLToArray($child,$attributesKey, $childrenKey,$valueKey);
            if(isset($children[$elementName])){
                if(is_array($children[$elementName])){
                    if($first){
                        $temp = $children[$elementName];
                        unset($children[$elementName]);
                        $children[$elementName][] = $temp;
                        $first=false;
                    }
                    $children[$elementName][] = $value;
                }else{
                    $children[$elementName] = array($children[$elementName],$value);
                }
            }
            else{
                $children[$elementName] = $value;
            }
        }
        if($children){
            if($childrenKey){$return[$childrenKey] = $children;}
            else{$return = array_merge($return,$children);}
        } 
        
        $attributes = array(); 
        foreach($xml->attributes() as $name=>$value){ 
            $attributes[$name] = trim($value); 
        } 
        if($attributes){ 
            if($attributesKey){$return[$attributesKey] = $attributes;}
            //else{$return = array_merge($return, $attributes);}
            else{$return = array_merge((array)$return, (array)$attributes);}
        } 
        
        return $return; 
    } 
?>


