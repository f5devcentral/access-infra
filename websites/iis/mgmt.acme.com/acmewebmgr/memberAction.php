<?php
include './config.inc';

switch($_POST['action']) {
  case "enable":
    $d="{\"state\":\"user-up\", \"session\":\"user-enabled\"}";
    break;
  case "disable":
    $d="{\"state\":\"user-up\", \"session\":\"user-disabled\"}";
    break;
  case "offline":
    $d="{\"state\":\"user-down\", \"session\":\"user-disabled\"}";
    break;
  case "kill":
    $d="{\"state\":\"user-down\", \"session\":\"user-enabled\"}";
    break;
  default:  
}

$cmd="curl -sk -u ".$userpass." https://".$bigip."/mgmt/tm/ltm/pool/".$_POST['pool']."/members/".$_POST['member']." -H 'Content-type: application/json' -X PATCH -d '".$d."'";
shell_exec($cmd);
sleep(2);
header('Location: https://mgmt.acme.com/acmewebmgr');
?>