<?php
$headers = apache_request_headers();
$groups=array_map('trim', explode("|",$headers['memberOf']));
foreach ($groups as $value) {
  if (!empty($value)) { $buttons[] = substr(trim($value),3,stripos($value, ',')-3); }
}
?>

<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
<head>
  <title>ACME Application/Service Portal</title>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
  <meta http-equiv='X-UA-Compatible' content='IE=edge' /> <!-- Make IE play nice -->
  <meta name='viewport' content='width=device-width, user-scalable=yes'/>
  <link rel='stylesheet' href="./css/main.css">
</head>
<body>
  <div class='header'>
    <div class='header-content'>
      <div class='header-image'><img src='./img/spy2.png' height='75px'></div>
      <div class='header-title'>ACME Application/Service Portal</div>
      <div class='header-subtitle'>Demo Applications</div>
    </div>
  </div>
  <div id="contentWrapper">
    <center><table width='60%'>
      <tr>
        <td width='50%'><center><br><br>
          <?php
            for ($a = 1; $a <= 2; $a++) {
//              if (in_array('app'.$a, $buttons)) { echo "<a href='./apps/app".$a."/' target='_BLANK'><img src='./img/app".$a."-button.png' width='300'></a><br>"; }
                echo "<a href='./apps/app".$a."/' target='_BLANK'><img src='./img/app".$a."-button.png' width='300'></a><br>"; 
            }
          ?>
        </center></td>
        <td width='50%'><center><br><br>
          <?php
//            if (in_array('member-services-A', $buttons)) { echo "<a href='./member/serviceA/' target='_BLANK'><img src='./img/serviceA-button.png' width='300'></a><br>"; }
//            if (in_array('member-services-B', $buttons)) { echo "<a href='./member/serviceB/' target='_BLANK'><img src='./img/serviceB-button.png' width='300'></a><br>"; }
//            if (in_array('sysadmins', $buttons)) { echo "<a href='./admin/' target='_BLANK'><img src='./img/app-admin-button.png' width='300'></a><br>"; }
              echo "<a href='./member/serviceA/' target='_BLANK'><img src='./img/serviceA-button.png' width='300'></a><br>"; 
              echo "<a href='./member/serviceB/' target='_BLANK'><img src='./img/serviceB-button.png' width='300'></a><br>"; 
              echo "<a href='./admin/' target='_BLANK'><img src='./img/app-admin-button.png' width='300'></a><br>"; 

          ?>
        </center></td>
      </tr>
      <tr>
        <td width='100%' colspan='2'><center>
          <a href='./vdesk/hangup.php3'><img src='./img/logout-button-hi.png' width='100'</a><br>
        </center></td>
      </tr>
    </table></center>
  </div>
</body>
</html>