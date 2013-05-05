<?php
    $host= gethostname();
    $ip = gethostbyname($host);
    //$ip = gethostbyname(trim(`hostname`));
    echo "hostname = $host";
    echo "CrystalSAN Server installed on $ip successfully";
    
?>
