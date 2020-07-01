<?php
session_start();
if(!isset($_SESSION['sid'])) {
  header("location: ./index.php?id=4");
}
else {
  include './mainFunc.inc';
  if(isset($_GET['page'])) { 
    $page=$_GET['page']; 
  } else {
    $page='home';
  }
  portalHeader();
  echo "<body>";
  pageHeader();
  pageNavbar();
  switch ($page) {
   case "home":
     include('./inc/home.inc');
     break;
   default:
     break; 
   }
 echo "<div id='footer'></div></body>";
 portalEnd();
}
?>
