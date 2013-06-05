<?php
    
    require ("public-parse-xml-proc.php");
    date_default_timezone_set('Asia/Manila');
    
    // usage: http://localhost/CrystalSANServer/test_parse_engine_all.php?site=Accusys&file=engine_40_all.xml
    
    echo date('l jS \of F Y h:i:s A') . "<br>";
    
    $file_name = $_REQUEST['file'];
    $site_name = $_REQUEST['site'];

    ini_set('display_errors', 'On');
    //error_reporting(E_ALL);

    try
    {
        
        $test = "ad0a8a";
        
        
        $database = "./" . $site_name . "/server.db";
        echo "database:" . $database . "<br>";
        
        $db = new PDO("sqlite:" . $database);

        $file = "./Accusys/Data/data_xml/" . $file_name;
        
        if (file_exists($file)) {
            
            echo "<br>file exist:" . $file . "<br>";
            // function parse_engine_all($file,$db,$site_name)
            parse_engine_all($file,$db,$site_name);
            
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



