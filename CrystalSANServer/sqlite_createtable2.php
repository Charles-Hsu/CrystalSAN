<?php
try 
{
    /*** connect to SQLite database ***/
    /* create table in root directory, i.e., /Library/WebServer/Documents */
    $dbh = new PDO("sqlite:VPN0.sqlite");
    echo "Handle has been created ...... <br><br>";
    $stm = "CREATE TABLE Friends(Id integer PRIMARY KEY," . 
        "Name text UNIQUE NOT NULL, Sex text CHECK(Sex IN ('M', 'F')))";
    $ok = $dbh->exec($stm);
}
catch(PDOException $e)
{
    echo $e->getMessage();
    echo "<br><br>Database -- NOT -- loaded successfully .. ";
    die( "<br><br>Query Closed !!! $error");
}

echo "Database loaded successfully ....";
?>
