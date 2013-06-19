<?php
    
    require ("public-parse-xml-proc.php");
    
    //date_default_timezone_set("Asia/Bangkok");
    date_default_timezone_set("Asia/Taipei");
    echo date('l jS \of F Y h:i:s A') . "<br>";
    
    $file_name = $_REQUEST['file'];
    $site_name = $_REQUEST['site'];

    ini_set('display_errors', 'On');
    error_reporting(E_ALL);
    
    //echo false;
    //if (preg_match('/engine_.+_all.xml/', $file_name)) {
    //    echo "parse_engine_...._all.xml";
    //}
    //return;

    try {
        $database = "./" . $site_name . "/server.db";
        echo "database:" . $database . "<br>";
        $db = new PDO("sqlite:" . $database);
        
        $file = "./$site_name/Data/data_xml/" . $file_name;
        if (file_exists($file)) {
            parse_engine_new($file,$db,$site_name);
            
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



