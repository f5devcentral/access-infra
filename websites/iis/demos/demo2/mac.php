<?php
  $ipAddress=$_SERVER['REMOTE_ADDR'];
  $arp=`arp -a $ipAddress`;
  $lines=explode("n", $arp);

  foreach($lines as $line){
    $cols=preg_split('/s+/', trim($line));
    if ($cols[0]==$ipAddress) {$macAddr=$cols[1];}
  }
echo $ipAddress;
echo $macAddr;

?>
