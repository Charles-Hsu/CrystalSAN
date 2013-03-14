<?php
$db = new SQLite3('mysqlitedb.db');

$db->exec('CREATE TABLE bar (bar STRING)');
?>
