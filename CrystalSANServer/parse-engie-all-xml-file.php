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
        //echo "<br>";
        
        //$full_xml_file = "./" . $site_name . "/Data/data_xml/" . $xml_file;
        
        $files = glob("./$site_name/Data/data_xml/*_all.xml");
        
        var_dump($files);
        
        $sql = "CREATE TABLE IF NOT EXISTS config_user (site_name, user_name, password, PRIMARY KEY (site_name, user_name))";
        $db->exec($sql);
        $sql = "INSERT INTO config_user VALUES ('" . $site_name ."', 'admin', '0000')";
        echo $sql;
        $db->exec($sql);
        
        foreach ($files as $key => $xml_file) {
            echo "<br/>$xml_file<br/>";
            parse_engine_all($xml_file, $db, $site_name);
        }

        
        //$full_xml_file = "./Accusys/Data/data_xml/engine_40_all.xml";
        /*
        echo "full_xml_file:" . $full_xml_file . "<br>";
        
        $myFile = "parse-engine-all-xml.log";
        $file_handle = fopen($myFile, 'a') or die("can't open file");
        
        $log = date('l jS \of F Y h:i:s A') . " " . $site_name . "," . $site_id  . "," . $client . "," . $data_type . "," . $data . "\n";
        fwrite($file_handle, $log);
        fwrite($file_handle, "full_xml_file:" . $full_xml_file . "\n");
        fclose($file_handle);
        
        if (file_exists($full_xml_file)) {
            echo "file $full_xml_file existed <br>";
            
            parse_engine_all($full_xml_file, $db);
            
            echo "file $full_xml_file existed <br>";
            
        } else {
            echo "file not exists";
        }
        */
        /*
        for($i=0; $i<300; $i++) {
            $file = $path . "engine_" . $i ."_all.xml";
            //echo $file;
            if (file_exists($file)) {
                echo $i+1 . ",";
                $filesNum++;
                if ($filesNum % 10 == 0) echo "<br>";
                
            }
        }
         */
        
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


