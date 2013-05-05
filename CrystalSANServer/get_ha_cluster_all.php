<?php
    
#  get_ha_cluster_all.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    ini_set("display_errors", "On");
    $site_name = $_REQUEST['site'] ;
    
    //echo $site_name;
    $sql = "";
    
    try
    {
        
        
        
        
        $database = "./" . $site_name . "/Data/server.db";
        //echo "sqlite3 " . $database . "<br>";
        
        $db = new PDO("sqlite:" . $database);
        
        $db->exec("CREATE TABLE IF NOT EXISTS temp_for_test (serial PRIMARY KEY, p0_wwpn)");
        
        //echo $db;
        
        $sql = "SELECT * FROM ha_cluster WHERE site_name='$site_name'";
        //echo $sql;
        
        
        //var_dump ($db->query($sql));
        $results = $db->query($sql)->fetchAll();

        //$i = 0;

        if (is_array($results)) {
            echo "<?xml version='1.0' encoding='UTF-8'?>";
            echo '<ha_cluster>';
            foreach($results as $key => $row) {
                //var_dump($row);
                //echo $row->vmirror_name;
                //print_r($row['vmirror_name']);
                $site_name = $row['site_name'];
                $engine00 = $row['engine00'];
                $engine01 = $row['engine01'];
                $engine02 = $row['engine02'];
                $engine03 = $row['engine03'];
                $engine04 = $row['engine04'];
                
                $ha_appliance_name = $row['ha_appliance_name'];
                
                //echo "[$ha]";
                
                echo "<site_name>$site_name</site_name>";
                echo "<ha_appliance_name>$ha_appliance_name</ha_appliance_name>";
                echo "<engine00>$engine00</engine00>";
                echo "<engine01>$engine01</engine01>";
                echo "<engine02>$engine02</engine02>";
                echo "<engine03>$engine03</engine03>";
                echo "<engine04>$engine04</engine04>";
                
            }
        } else {
            echo "is not a array";
        }

        echo '</ha_cluster>';
        $db = null; // Close file db connection
        
    }
    catch(PDOException $e)
    {
        echo $e->getMessage();
        echo "<br><br>SQL=$sql";
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }



?>