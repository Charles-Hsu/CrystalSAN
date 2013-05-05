<?php
    
    require ("public-parse-xml-proc.php");
    
    echo date('l jS \of F Y h:i:s A') . "<br>";
    
    //$startDate = date('i:s');//'2011-01-21 09:00:00';
    //echo "timestamp=>" . date_timestamp_get() . "<br>";
    $start = gettimeofday(true);
    
    //$start = date_create();
    
    $filesNum = 0;
    
    try
    {
        $path = "./data_xml/";
        
        $db = new PDO("sqlite:server.db");
        echo "<br>";
        
        for($i=0; $i<300; $i++) {
            $file = $path . "engine_" . $i ."_all.xml";
            //echo $file;
            if (file_exists($file)) {
                echo $i+1 . ",";
                $filesNum++;
                if ($filesNum % 10 == 0) echo "<br>";
                parse_engine_all($file, $db);
            }
        }
        
        $db = null; // Close file db connection
        
    }
    catch(PDOException $e)
    {
        echo $e->getMessage();
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }
    
    echo "<br>" . date('l jS \of F Y h:i:s A') . "<br>";
    
    $end = gettimeofday(true);
    

    //$end = date_create();
    
    //$endDate = date('i:s');
    
    // time span seconds
    //$sec = explode(':', (gmdate('Y:m:d:H:i:s', strtotime($endDate) - strtotime($startDate))));
    //var_dump($sec);

    
    //echo timeDifference($end, $start);
    
    //$interval = $start->diff($end);
    //$avg = $interval / $filesNum;
    //echo $interval->format('%I:%S');
    //$sec = $endDate - $startDate;
    $total = round(($end-$start),2);
    $sec = round(($end-$start)/$filesNum,2);
    echo "<br>total " . $filesNum . " file(s), $total second(s)<br>";
    echo  $sec . " sec(s) per file";
    //echo round($sec/$filesNum, 2) . " seconds/file<br>";
    //echo $avg->format('%I:%S');
    
?>



