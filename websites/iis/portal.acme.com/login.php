<?php
session_start();
#######################################
// Function Includes
  include './mainFunc.inc';

// Local Auth
if (!$_POST['uid'] || !$_POST['pwd']) {
  header('location: ./index.php?id=1');
} else {
  if ( ($_POST['uid']=='testuser') && ($_POST[pwd]=='p4$$w0rd') ) {
    $_SESSION['sid']=md5($_POST['uid'].$_POST['pwd']);
    header('location: ./main.php?page=home');      
  } else {
    header('location: ./index.php?id=2');
  }
}
?>