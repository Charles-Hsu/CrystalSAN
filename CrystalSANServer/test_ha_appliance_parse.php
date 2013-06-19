<?php
    
    require ("public-parse-xml-proc.php");
    
    echo date('l jS \of F Y h:i:s A') . "<br>";
    
    $file_name = $_REQUEST['file'] ;

    ini_set('display_errors', 'On');
    //error_reporting(E_ALL);

    try
    {
        $db = new PDO("sqlite:server.db.test");
        
        $file = "./Accusys/Data/data_xml/" . $file_name;
        
        if (file_exists($file)) {
            
            echo "<br>file exist:" . $file . "<br>";
            // ha_appliance_parsing ($db, $site_name, $serial);
            parse_engine_all($file,$db);
            
        } else {
            
            exit('Failed to open ' . $file . '.');
        }
  
        $db = null; // Close file db connection
        


    }
    catch(PDOException $e)
    {
        echo $e->getMessage();
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }
    
?>



