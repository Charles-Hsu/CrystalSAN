<?php
    
    ini_set("display_errors", "On");
    ini_set("log_errors_max_len", 100);
    
    $site_name = @$_GET['site'] ;
    $user_name = @$_GET['user'] ;
    $password =  @$_GET['password'] ;
    
    try
    {
        
        if (isset($site_name) && isset($user_name) && isset($password)) {
            
            $database = "./" . $site_name . "/server.db";
            $db = new PDO("sqlite:" . $database);
            
            $sql = "SELECT count(*) FROM config_user WHERE site_name='$site_name' AND user_name='$user_name' AND password='$password'";
            $result = $db->query($sql)->fetchAll();
            
            //var_dump($result);
            
            $row = $result[0];
            echo $row[0];
            
            //foreach($result as $key => $row) {
                //var_dump($row);
                //var_dump($row[0]);
            //}
            $db = null; // Close file db connection
        } else {
            echo "0";
        }
        
    }
    catch(PDOException $e)
    {
        echo $e->getMessage();
        echo "<br><br>Database -- NOT -- loaded successfully .. ";
        die( "<br><br>Query Closed !!! $error");
    }
    

    
    
?>
