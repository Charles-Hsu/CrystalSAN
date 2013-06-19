<?php
    
    require ("public-parse-xml-proc.php");
    
    echo date('l jS \of F Y h:i:s A') . "<br>";
    
    $file_name = $_REQUEST['file'];
    $site_name = $_REQUEST['site'];

    ini_set('display_errors', 'On');
    //error_reporting(E_ALL);

    try {
        $database = "./" . $site_name . "/server.db";
        echo "database:" . $database . "<br>";
        $db = new PDO("sqlite:" . $database);
        
        $file = "./$site_name/Data/data_xml/" . $file_name;
        if (file_exists($file)) {
            parse_engine_time($file,$db,$site_name);
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



