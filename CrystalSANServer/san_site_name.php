<?php
$db = new SQLite3('san.sqlite');

$results = $db->query('SELECT vmirror_name FROM site_name');
echo '<site_name>';
while ($row = $results->fetchArray()) {
    //var_dump($row);
    //echo $row->vmirror_name;
    //print_r($row['vmirror_name']);
    $vmirror = $row['vmirror_name'];
    echo "<vmirror_name>$vmirror</vmirror_name>";
    //echo '<br>';
}
echo '</site_name>';
?>
