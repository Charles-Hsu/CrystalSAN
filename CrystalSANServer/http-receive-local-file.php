<?php
    
    date_default_timezone_set('Asia/Manila');
    //error_reporting(0);
    error_reporting(E_ERROR);// | E_WARNING | E_PARSE);

    ///////////////////////////////////////////////////////////////////////////////////////
    
    function logInfo($message) {
        $site_name = $_REQUEST['site'] ;
        //echo $site_name;
        $today = date("Ymd");
        $file_name = "./$site_name/$today.log";
        echo $file_name;
        $log_file = fopen($file_name, 'a') or die("can't open file");
        fwrite($log_file, $message);
        fclose($log_file);
    }
    

    $today = date("Ymd");
    $error_log_file_name = "./$today"."_error.log";
    echo $error_log_file_name;
    
    ini_set("display_errors", "On");
    ini_set("log_errors_max_len", 100);
    ini_set('log_errors', 1);     //turn on log error
    ini_set('error_log', $error_log_file_name);  //log to file
    
    require ("public-parse-xml-proc.php");
    
    $site_name = $_REQUEST['site'] ;
    $site_id = $_REQUEST['id'] ;
    $client = $_REQUEST['client'] ;
    $data_type = $_REQUEST['type'] ;
    $data = $_REQUEST['data'] ;

    $log = date('l jS \of F Y h:i:s A') . "site=$site_name&id=$site_id&client=$client&type=$data_type&data=$data\n";
    
    logInfo($log);
    
    if (1) {
        
        if (preg_match ( "/(.*\.txt)$/", $data_type, $result)) {
            $file_name = $result[1];$type = "txt";
        } else if (preg_match ( "/(.*\.xml)$/", $data_type, $result)) {
            $file_name = $result[1];$type = "xml";
        } else if (preg_match ( "/(.*\.html)$/", $data_type, $result)) {
            $file_name = $result[1];$type = "html";
        } else if ($data_type == "test") {
            exit("test --- send back the same data:$data");
        } else if ($data_type == "command") {
            //$data = "<sites><site><site_id>123456</site_id><user>Jesse Wu</user><acl>987654</acl><exp>engine-CLI-command.exp</exp><ip>12 34 all</ip><option>conmgr drive status></site></sites>";
            /// check and send data back if exists
            //exit($site_name."/Data/data_xml/command_remote_1.xml");
            if (!file_exists($site_name."/Data/data_xml"))  {mkdir($site_name."/Data/data_xml");}
            if (file_exists($site_name."/Data/data_xml/command_remote.xml"))  {
                print(file_get_contents($site_name."/Data/data_xml/command_remote.xml"));
                unlink($site_name."/Data/data_xml/command_remote.xml");
                exit;
            } else exit("no commands");
        } else {exit("///// ERROR : webserver cannot deal with the type: $data_type=====");}
        
        if (!file_exists($site_name)) {mkdir($site_name);}
        if (!file_exists($site_name."/Data")) {mkdir($site_name."/Data");}
        if (!file_exists($site_name."/Data/data_txt")) {mkdir($site_name."/Data/data_txt");}
        if (!file_exists($site_name."/Data/data_xml"))  {mkdir($site_name."/Data/data_xml");}
        if (!file_exists($site_name."/Data/data_html"))  {mkdir($site_name."/Data/data_html");}
        
        if ($type == "txt")         {$folder = $site_name."/Data/data_txt";}
        else if ($type == "xml")    {$folder = $site_name."/Data/data_xml";}
        else if ($type == "html")   {$folder = $site_name."/Data/data_html";}
        else {exit("ERROR :not txt, xml or html file: $filename !!");};
        
        $data = preg_replace("/\\\\\'|\"/", "'", $data);
        $data = preg_replace("/\\\\\'|\"/", "'", $data);
        
        $file=fopen($folder . "/" . $file_name, "w") or exit("Unable to open file: $file_name !");
        fwrite($file, $data);
        fclose($file);
        
        try {
            $full_file_name = "$folder/$file_name";
            //$log = date('l jS \of F Y h:i:s A') . " " . "Found " . $full_file_name . "\n";
            
            $database = "./$site_name/server.db";
            $db = new PDO("sqlite:" . $database);
            
            if (file_exists($full_file_name)) {
                //if (strpos($file_name,'all') != false) {
                if (preg_match('/engine_.+_all.xml/', $file_name)) {
                    parse_engine_all($full_file_name, $db, $site_name);
                } else if (preg_match('/engine_new.xml/', $file_name)) { // engine_new.xml
                    parse_engine_new($full_file_name, $db, $site_name);
                }
            }
            
            $db = null; // Close file db connection
        } catch(PDOException $e) {
            echo $e->getMessage();
            echo "<br><br>Database -- NOT -- loaded successfully .. ";
            die( "<br><br>Query Closed !!! $error");
        }
    
    }
    print "Done";

    
    
?> 
