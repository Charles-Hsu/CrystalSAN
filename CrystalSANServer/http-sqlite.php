<?php
    
#  http-get-ha_cluster.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/7/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    ini_set("display_errors", "On");
    
    $site_name = @$_REQUEST['site'];
    $sql = @$_REQUEST['sql'];
    
    echo "$sql<br>";
    
    try {
        if (isset($site_name) && !empty($site_name)) {
            $database = "./" . $site_name . "/server.db";
            
            if (file_exists($database)) {
                $db = new PDO("sqlite:" . $database);
                $results = $db->query($sql)->fetchAll();
                var_dump($results);
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