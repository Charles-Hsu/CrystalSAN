<?php
    
    echo date('l jS \of F Y h:i:s A') . "<br>";
    ini_set('display_errors', 'On');
    $r = new HttpRequest('http://example.com/', HttpRequest::METH_GET);
    
    
?>


