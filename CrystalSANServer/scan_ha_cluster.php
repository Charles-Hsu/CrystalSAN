<?php
    
    //require ("public-parse-xml-proc.php");
    
    echo date('l jS \of F Y h:i:s A') . "<br>";

    try
    {
        /*** connect to SQLite database ***/
        $db = new PDO("sqlite:server.db");
        
        $sql = "CREATE TABLE IF NOT EXISTS ha_cluster (site_name, ha_appliance_name, engine00 PRIMARY KEY, engine01, engine02, engine03, engine04)";
        $db->exec($sql);
        
        $sql = "select b.site_name, a.serial 'SN',a.cluster_id,substr(a.p0_wwpn,6),b.engine_name,substr(b.a1_wwpn,6) from engine_cli_conmgr_engine_status a, engine_cli_vpd b where a.serial=b.serial and a.cluster_id=2";
        
        //echo "Test Data Insert Complete\n";
        $r = $db->query($sql);
        $i = 0;
        while ($row = $r->fetch(SQLITE_ASSOC)) {
            echo $i;
            echo "<br>";
            $i++;
        }


    }
    catch(PDOException $e)
    {
        echo $e->getMessage();
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }
    
?>



