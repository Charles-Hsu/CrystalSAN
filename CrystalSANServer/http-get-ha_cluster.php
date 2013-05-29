<?php
    
#  http-get-ha_cluster.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    ini_set("display_errors", "On");
    
    $site_name = @$_REQUEST['site'] ;
    $seconds = @$_REQUEST['seconds'] ;
    $sql = "";
    
    try {
        if (isset($site_name) && !empty($site_name)) {
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                $db = new PDO("sqlite:" . $database);
                $sql = "SELECT * FROM ha_cluster WHERE site_name='$site_name'";
                //echo $sql;
                if (isset($seconds) && !empty($seconds)) {
                    $sql .= " AND seconds > $seconds";
                }
                
                //echo $sql;
                
                $results = $db->query($sql);
                //var_dump($results);
                //$i = 0;
                
                //if (is_array($results)) {
                    echo '<ha_cluster>';
                    foreach($results as $key => $row) {
                        echo '<record>';
                        $seconds  = $row['seconds'];
                        $site_name = $row['site_name'];
                        $engine00 = $row['engine00'];
                        $engine01 = $row['engine01'];
                        $engine02 = $row['engine02'];
                        $engine03 = $row['engine03'];
                        $engine04 = $row['engine04'];
                        
                        $ha_appliance_name = $row['ha_appliance_name'];
                        
                        echo "<seconds>$seconds</seconds>";
                        echo "<site_name>$site_name</site_name>";
                        echo "<ha_appliance_name>$ha_appliance_name</ha_appliance_name>";
                        echo "<engine00>$engine00</engine00>";
                        echo "<engine01>$engine01</engine01>";
                        echo "<engine02>$engine02</engine02>";
                        echo "<engine03>$engine03</engine03>";
                        echo "<engine04>$engine04</engine04>";
                        echo '</record>';
                    }
                    echo '</ha_cluster>';
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