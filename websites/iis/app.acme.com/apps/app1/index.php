<?php
$headers = apache_request_headers();
?>

<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
<head>
  <title>Application 1</title>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
  <meta http-equiv='X-UA-Compatible' content='IE=edge' /> <!-- Make IE play nice -->
  <meta name='viewport' content='width=device-width, user-scalable=yes'/>
  <link rel='stylesheet' href='/css/main.css'>
</head>
<body>
  <div class='header'>
    <div class='header-content'>
      <div class='header-image'><img src='/img/app1_icon.png' height='75px'></div>
      <div class='header-title'>Application 1</div>
      <div class='header-subtitle'>Demo Application</div>
    </div>
  </div>
  <div id="contentWrapper">
    <div id="contentBox">
      <div class="contentBoxCentered">
        <table width='96%' border='1' style='table-layout: fixed;'>
          <?php
            foreach ($headers as $header => $value) {
              if ( ($header!="F5-Client-Information") && ($header!="Content-Type") ) {
                echo "<tr><td>".$header."</td><td style='word-wrap: break-word'>".$value."</td></tr>";
              }
            }
          ?>
        </table> 
      </div>
    </div>
  </div>
</body>
</html>
