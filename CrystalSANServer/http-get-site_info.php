<?php
    
#  http-get-ha_cluster.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    ini_set("display_errors", "On");
    
    $site_name = @$_REQUEST['site'];
    $user_name = @$_REQUEST['user'];
    $password  = @$_REQUEST['password'];
    
    try {
        if (isset($site_name) && !empty($site_name)) {
            $database = "./client_config.db";
            
            if (file_exists($database)) {
                $db = new PDO("sqlite:" . $database);
                $sql = "SELECT location,name,address,longitude,latitude FROM site_info WHERE site_name='$site_name' AND user_name='$user_name' AND password='$password'";
                //echo $sql;
                $results = $db->query($sql);
                echo "<site_info>";
                foreach($results as $key => $row) {
                    $location = $row['location'];
                    $name = $row['name'];
                    $address = $row['address'];
                    $longitude = $row['longitude'];
                    $latitude = $row['latitude'];
                    echo '<record>';
                    echo "<location>$location</location>";
                    echo "<name>$name</name>";
                    echo "<address>$address</address>";
                    echo "<longitude>$longitude</longitude>";
                    echo "<latitude>$latitude</latitude>";
                    echo '</record>';
                }
                echo "</site_info>";
            }
        }

        $db = null; // Close file db connection

    } catch(PDOException $e) {
        echo $e->getMessage();
        echo "<br><br>SQL=$sql";
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }

    
    //5F., No.38, Taiyuan St., Jhubei City, Hsinchu Country 30265, Taiwan R.O.C.
    
?>