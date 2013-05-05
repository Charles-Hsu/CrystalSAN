<?php
    
#  get_account.php
#  CrystalSAN
#
#  Created by Charles Hsu on 3/13/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

    $db = new SQLite3('server.db');
    $site_name = $_GET['site_name'];
    $site_id = $_GET['site_id'];
    $user_name = $_GET['user_name'];
    
    $sql = "SELECT password FROM account WHERE site_name='$site_name' AND site_id='$site_id' AND user_name='$user_name'";
    
    $results = $db->query($sql);
    if ($row = $results->fetchArray()) {
        $password = $row['password'];
        echo "<password>$password</password>";
    }

    
    
?>