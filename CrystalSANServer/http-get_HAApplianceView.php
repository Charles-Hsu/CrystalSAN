<?php
    
#  http-get-ha_cluster.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    ini_set("display_errors", "On");
    
    $site_name = @$_REQUEST['site'] ;
    //$seconds = @$_REQUEST['seconds'] ;
    $sql = "";
    
    try {
        if (isset($site_name) && !empty($site_name)) {
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                $db = new PDO("sqlite:" . $database);
                $sql = "SELECT ha_appliance_name,engine01,engine02 FROM ha_cluster WHERE site_name='$site_name'";
                //echo $sql;
                //if (isset($seconds) && !empty($seconds)) {
                //    $sql .= " AND seconds > $seconds";
                //}
                //echo $sql;
                $results = $db->query($sql);
                //var_dump($results);
                //$i = 0;
                
                $table_name = preg_replace('/http-get_/', '', basename(__FILE__, '.php'));
                
                //echo "table_name = $table_name";
                
                
                //if (is_array($results)) {
                    echo "<$table_name>";
                    foreach($results as $key => $row) {
                        echo '<record>';
                        //$seconds  = $row['seconds'];
                        //$site_name = $row['site_name'];
                        //$engine00 = $row['engine00'];
                        $ha_appliance_name = $row['ha_appliance_name'];
                        $engine01 = $row['engine01'];
                        $engine02 = $row['engine02'];
                        //$engine03 = $row['engine03'];
                        //$engine04 = $row['engine04'];
                        $sql = "SELECT alert FROM engine_cli_vpd WHERE serial='$engine01' LIMIT 1";
                        $results = $db->query($sql)->fetchAll();
                        $alert=$results[0]['alert'];
                        echo "<ha_appliance_name>$ha_appliance_name</ha_appliance_name>";
                        //var_dump($alert);
                        if ($alert!="None") {
                            echo '<alert>1</alert>';
                        }
                        
                        //echo "<seconds>$seconds</seconds>";
                        //echo "<site_name>$site_name</site_name>";
                        //echo "<ha_appliance_name>$ha_appliance_name</ha_appliance_name>";
                        //echo "<engine00>$engine00</engine00>";
                        //echo "<engine01>$engine01</engine01>";
                        //echo "<engine02>$engine02</engine02>";
                        //echo "<engine03>$engine03</engine03>";
                        //echo "<engine04>$engine04</engine04>";
                        echo '</record>';
                    }
                    echo "</$table_name>";
                //}
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