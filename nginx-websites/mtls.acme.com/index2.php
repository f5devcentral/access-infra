<?php
  echo "Using PHP OpenSSL Library<br>";
  $cert=openssl_x509_parse($_SERVER['X_SSL_CERTRAW']);
  print("<pre>".print_r($cert,true)."</pre>");
?>