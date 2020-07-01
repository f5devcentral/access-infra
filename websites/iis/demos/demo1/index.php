<?php
  $color="red";
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
  $SERVER_ADDR=isset($_SERVER['SERVER_ADDR']) ? $_SERVER['SERVER_ADDR'] : null;
  $SERVER_PORT=isset($_SERVER['SERVER_PORT']) ? $_SERVER['SERVER_PORT'] : null;
  $SERVER_PROTOCOL=isset($_SERVER['SERVER_PROTOCOL']) ? $_SERVER['SERVER_PROTOCOL'] : null;

  $cookie_name = "supersecretcookie";
  $cookie_value = "mysecret";
  setcookie($cookie_name, $cookie_value, time() + (86400 * 30), "/"); // 86400 = 1 day
?>

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
  <div class='header' style='<?php echo ${$color."_shadow"} ?>'><div class='header-content'>
    <div class='header-title'>ACME APP</div>
    <div class='header-subtitle'>Pool Member:  <?php echo gethostbyaddr($SERVER_ADDR); ?></div>
  </div></div>
  <div class='contentWrapper'><div class='contentBox'>
    <table class='layout'><tr><td class='f5'>  
      <?php
         $headers = apache_request_headers();
         // echo "<img src='https://app.acme.com/demos/demo1/img/f5a.png' width='150px' style='vertical-align: middle;'>"; 
         echo "<img src='http://app.acme.com/demos/demo1/img/f5a.png' width='150px' style='vertical-align: middle;'>"; 
         // echo "<img src='./img/f5a.png' width='150px' style='vertical-align: middle;'>";  
      ?>
    </td></tr></table>      
  </div></div>
  <a href="http://www.chas.one/"> chas </a>
  <div class='footer'><div class='footer-content'><div class='footer-title'><?php echo gethostbyaddr($SERVER_ADDR); ?></div></div></div>
</body>
</html>
