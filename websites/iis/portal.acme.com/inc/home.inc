 <?php 
 $headers = apache_request_headers();
  echo "<div id='contentWrapper'><div id='contentBox'><div class='contentBoxCentered'><table width='96%' border='1'>";
  foreach ($headers as $header => $value) {
    if ($header=="homeDirectory") {
      echo "<tr><td>".$header."</td><td><img src='".$value."'></td></tr>";
    } else {
      echo "<tr><td>".$header."</td><td>".$value."</td></tr>";
    }
  }
  echo "</table></div></div></div>";
?>