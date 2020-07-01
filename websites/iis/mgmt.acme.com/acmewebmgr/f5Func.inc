<?php
function f5_Data($url) {
  $headers = array('Content-Type: application/json');
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
  curl_setopt($ch, CURLOPT_USERPWD, "admin:acme");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $errmsg = curl_error($ch);
  $cInfo = curl_getinfo($ch);
  curl_close($ch);
  return $response;
}

function f5_Status_Icon($parm1,$parm2) {
//  echo "<br> parm1=>".$parm1.",parm2=>".$parm2."<br>";
  include './codes.inc';
  if (!empty($parm2)) {
    $icon=${strtr($parm1,"-","_")."_".strtr($parm2,"-","_")};
  } else {
    $icon=${$parm1};
  }
  return $icon;
}
?>
