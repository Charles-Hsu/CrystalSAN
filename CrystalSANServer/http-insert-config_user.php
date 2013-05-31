<?php
    
    date_default_timezone_set('Asia/Manila');

    ini_set("display_errors", "On");
    ini_set("log_errors_max_len", 100);

    
    $site_name = $_REQUEST['site'] ;
    //$xml_file  = $_REQUEST['xml'] ;
    
    require ("public-parse-xml-proc.php");
    echo "site_name = $site_name<br>";
    
    echo date('l jS \of F Y h:i:s A') . "<br>";
    
    $filesNum = 0;
    
    //$r = new HttpRequest('http://www.google.com/', HttpRequest::METH_GET);

    try
    {
        $database = "./" . $site_name . "/server.db";
        echo "database:" . $database . "<br>";
       
        $db = new PDO("sqlite:" . $database);
        
        $sql = "CREATE TABLE IF NOT EXISTS config_user (site_name, user_name, password, PRIMARY KEY (site_name, user_name))";
        $db->exec($sql);
        $sql = "INSERT INTO config_user VALUES ('" . $site_name ."', 'admin', '0000')";
        echo $sql;
        $db->exec($sql);
                
        $db = null; // Close file db connection
        
    }
    catch(PDOException $e)
    {
        echo $e->getMessage();
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }
    
    echo "<br>" . date('l jS \of F Y h:i:s A') . "<br>";
    
?>


