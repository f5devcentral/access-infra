<?php
  session_start();  
  mysqli_close ( $_SESSION['link'] );
  session_destroy();
  header('location: http://ordoghaz.underworld.net/portal/');
?>