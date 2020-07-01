<?php
  session_start();  
  session_destroy();
  header('location: https://portal.acme.com/');
?>