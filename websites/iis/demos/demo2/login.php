<?php
// session_start();
// #######################################
// Function Includes
//  include './mainFunc.inc';

// Login (LDAP Bind Validation)
// if (!$_POST['uid'] || !$_POST['pwd']) {
//  header('location: ./index.php?id=1');
// } else {
//  $bind=valBind($_POST['uid'],$_POST['pwd']);
//  switch($bind) {
//    case 0:
//      header('location: ./index.php?id=2');
//      break;
//    case 1:
//      $_SESSION['sid']=md5($_POST['uid'].$_POST['pwd']);
//      header('location: ./main.php?page=home');      
//      break;
//  }
// }
print_r($_POST);
?>