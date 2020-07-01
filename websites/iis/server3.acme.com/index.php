<?php
  $color="blu";
  $red_shadow="-moz-box-shadow: inset 0 30px 30px -30px rgba(178, 34, 34, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); -webkit-box-shadow: inset 0 30px 30px -30px rgba(178, 34, 34, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); box-shadow: inset 0 30px 30px -30px rgba(178, 34, 34, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5);";
  $grn_shadow="-moz-box-shadow: inset 0 30px 30px -30px rgba(34, 139, 34, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); -webkit-box-shadow: inset 0 30px 30px -30px rgba(34, 139, 34, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); box-shadow: inset 0 30px 30px -30px rgba(34, 139, 34, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5);";
  $blu_shadow="-moz-box-shadow: inset 0 30px 30px -30px rgba(70, 130, 180, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); -webkit-box-shadow: inset 0 30px 30px -30px rgba(70, 130, 180, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); box-shadow: inset 0 30px 30px -30px rgba(70, 130, 180, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5);";
  $wht_shadow="-moz-box-shadow: inset 0 30px 30px -30px rgba(70, 130, 180, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); -webkit-box-shadow: inset 0 30px 30px -30px rgba(70, 130, 180, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5); box-shadow: inset 0 30px 30px -30px rgba(70, 130, 180, 0.5), 0 20px 20px -20px rgba(0, 0, 0, 0.5);";
  $red_bckgrnd="background-color: #b22222;";
  $grn_bckgrnd="background-color: #228b22;";
  $blu_bckgrnd="background-color: #4682b4;";
  $wht_bckgrnd="background-color: #ffffff;";
  $XFF=isset($_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : null;
  $XFF_PROTO=isset($_SERVER['HTTP_X_FORWARDED_PROTO']) ? $_SERVER['HTTP_X_FORWARDED_PROTO'] : null;
  $XFF_PROTOVER=isset($_SERVER['HTTP_X_FORWARDED_PROTOVER']) ? $_SERVER['HTTP_X_FORWARDED_PROTOVER'] : null;
  $XFF_PORT=isset($_SERVER['HTTP_X_FORWARDED_PORT']) ? $_SERVER['HTTP_X_FORWARDED_PORT'] : null;
  $USER_AGENT=isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : null;
  $REQUEST_URI=isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : null;
  $HTTP_HOST=isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : null;
  $SSL_CIPHER=isset($_SERVER['HTTP_SSL_CIPHER']) ? $_SERVER['HTTP_SSL_CIPHER'] : null;
  $REMOTE_ADDR=isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : null;
  $SERVER_ADDR=isset($_SERVER['LOCAL_ADDR']) ? $_SERVER['LOCAL_ADDR'] : null;
  $SERVER_PORT=isset($_SERVER['SERVER_PORT']) ? $_SERVER['SERVER_PORT'] : null;
  $SERVER_PROTOCOL=isset($_SERVER['SERVER_PROTOCOL']) ? $_SERVER['SERVER_PROTOCOL'] : null;
?>
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
<head>
  <title>ACME Application</title>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
  <meta http-equiv='X-UA-Compatible' content='IE=edge' /> <!-- Make IE play nice -->
  <meta name='viewport' content='width=device-width, user-scalable=yes'/>
  <meta http-equiv='refresh' content='7'>
  <link rel='stylesheet' href='./main.css'>
</head>
<body style='<?php echo ${$color."_bckgrnd"} ?>'>
  <!-- ServerIsUp-->
  <div class='header' style='<?php echo ${$color."_shadow"} ?>'>
    <div class='header-content'>
      <div class='header-title'>ACME APP</div>
      <div class='header-subtitle'>Pool Member:  <?php echo gethostbyaddr($SERVER_ADDR); ?></div>
    </div>
  </div>
  <div class='contentWrapper'>
    <div class='contentBox'>
      <table class='layout'>
        <tr>
          <td class='left'>
            <?php
              $headers = apache_request_headers();
              echo "<table class='data'>";
              echo "<tr><td class='title' colspan='2'><font ='4.5em'>CLIENT-SIDE</font><img src='./img/c_to_f5.png' width='150px' style='vertical-align: middle;'></td></tr>";
              echo "<tr><td class='subtitle'>Header</td><td class='subtitle'>Element</td></tr>";
              echo "<tr><td class='key'>Client Address:</td><td class='value'>".$XFF."</td></tr>";
              echo "<tr><td class='key'>User Agent:</td><td class='value'>".$USER_AGENT."</td></tr>";
              echo "<tr><td class='key'>Requested URL:</td><td class='value'>".$XFF_PROTO."://".$HTTP_HOST.$REQUEST_URI."</td></tr>";
              echo "<tr><td class='key'>F5 Virtual Server:</td><td class='value'>".gethostbyname($HTTP_HOST)." (".$HTTP_HOST.")</td></tr>";
              echo "<tr><td class='key'>Destination Port:</td><td class='value'>".$XFF_PORT."</td></tr>";
              echo "<tr><td class='key'>Protocol:</td><td class='value'>".$XFF_PROTO."</td></tr>";
              echo "<tr><td class='key'>HTTP Version:</td><td class='value'>".$XFF_PROTOVER."</td></tr>";
              if ($XFF_PROTO=='https') {
                echo "<tr><td class='key'>Negotiated SSL:</td><td class='value'>".$SSL_CIPHER."</td></tr>";
              }
              echo "</table><br>";
            ?>
          </td>
          <td class='f5'>  
            <?php
              $headers = apache_request_headers();
              echo "<img src='./img/f5a.png' width='150px' style='vertical-align: middle;'>";  
            ?>
          </td>
          <td class='right'>
            <?php
              $headers = apache_request_headers();
              echo "<table class='data'>";
              echo "<tr><td class='title' colspan='2'><img src='./img/f5_to_s.png' width='150px' style='vertical-align: middle;'><font ='4.5em'>SERVER-SIDE</font></td></tr>";
              echo "<tr><td class='subtitle'>Header</td><td class='subtitle'>Element</td></tr>";
              echo "<tr><td class='key'>F5 Self-IP:</td><td class='value'>".$REMOTE_ADDR." (".gethostbyaddr($REMOTE_ADDR).")</td></tr>";
              echo "<tr><td class='key'>Client (XFF):</td><td class='value'>".$XFF." (".gethostbyaddr($XFF).")</td></tr>";
              echo "<tr><td class='key'>Pool Member:</td><td class='value'>".$SERVER_ADDR." (".gethostbyaddr($SERVER_ADDR).")</td></tr>";
              echo "<tr><td class='key'>Pool Member Port:</td><td class='value'>".$SERVER_PORT."</td></tr>";
              echo "<tr><td class='key'>Requested URI:</td><td class='value'>".$REQUEST_URI."</td></tr>";
              echo "<tr><td class='key'>HTTP Version:</td><td class='value'>".$SERVER_PROTOCOL."</td></tr>";
              echo "</table>"; 
            ?>
          </td>
        </tr>
      </table>      
    </div>
  </div>
  <div class='footer'>
    <div class='footer-content'>
      <div class='footer-title'><?php echo gethostbyaddr($SERVER_ADDR); ?></div>
    </div>
  </div>
</body>
</html>
