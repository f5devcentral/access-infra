<?php
  $cert= $_SERVER['X_SSL_CERTRAW']; 

  set_include_path(get_include_path() . PATH_SEPARATOR . "/inc/phpseclib");
  include('./inc/phpseclib/File/X509.php');
  include('./inc/phpseclib/Math/BigInteger.php');
  include('./inc/user_array.inc');

  $x509 = new File_X509();
  $xcert=$x509->loadX509($cert);

  $ci = count($xcert['tbsCertificate']['issuer']['rdnSequence']);
  for ($i = 0; $i <= $ci; $i++) {
    if ($xcert['tbsCertificate']['issuer']['rdnSequence'][$i][0]['type'] == "id-at-commonName") {
      $issuer = strtolower($xcert['tbsCertificate']['issuer']['rdnSequence'][$i][0]['value']['printableString']);
      $i=$ci;
    }
  }  

  $cc = count($xcert['tbsCertificate']['subject']['rdnSequence']);
  for ($i = 0; $i <= $cc; $i++) {
    if ($xcert['tbsCertificate']['subject']['rdnSequence'][$i][0]['type'] == "id-at-commonName") {
      $subject = strtolower($xcert['tbsCertificate']['subject']['rdnSequence'][$i][0]['value']['printableString']);
    #  $i=$cc;
    }
  }  

  $ce = count($xcert['tbsCertificate']['extensions']);
  for ($e = 0; $e <= $ce; $e++) {
     switch ($xcert['tbsCertificate']['extensions'][$e]['extnId']) {
      case "id-ce-subjectAltName":
        $cv = count($xcert['tbsCertificate']['extensions'][$e]['extnValue']); 
        for ($v = 0; $v <= $cv; $v++) {
          foreach($xcert['tbsCertificate']['extensions'][$e]['extnValue'][$v] as $key => $value) {
            if ($key == "otherName") {
              $altuser = strtolower($xcert['tbsCertificate']['extensions'][$e]['extnValue'][$v][$key]['value']['utf8String']);
              $v=$cv;
            }
          } 
        }
        break;
      case "1.1.1.1":
        $xuser = explode("=", base64_decode($xcert['tbsCertificate']['extensions'][$e]['extnValue']));
        $extuser = strtolower($xuser[1]);
        break;
      default:
        $user = "Unknown";
        break;
    }
  } 
  $serial = new Math_BigInteger($xcert['tbsCertificate']['serialNumber']);
  $xserial = substr($serial->toHex(),-12);
?>
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="./css/card-main.css">
    <script>
      window.onload = function() {
        document.getElementById('status').style.display = "none";
      }
      function changeStatus() {
        var x = document.getElementById("status");
        if (x.style.display === "none") {
          x.style.display = "block";
        } else {
          x.style.display = "none";
        }
      } 
    </script>
  </head>


  <body>
    <div class="card">
      <img src="./img/<?php echo $users[$extuser]['image']; ?>" style="width:100%">
      <h1><?php echo $users[$extuser]['name']; ?></h1>
      <p class="title"><?php echo $users[$extuser]['title']; ?></p>
      <table>
        <tr><td class="lt">F5 Agility Lab</td><td class="rt"><img src="./img/chip.png" width="50px"></td></tr>
        <tr><td class="lt">Cert Subject:</td><td class="rt"><?php echo $subject; ?></td></tr>
        <tr><td class="lt">Subject Alt:</td><td class="rt"><?php if (isset($altuser)) {echo $altuser; } else {echo "&lt;empty&gt;"; } ?></td></tr>
        <tr><td class="lt">Custom Ext:</td><td class="rt"><?php echo $extuser; ?></td></tr>
        <tr><td class="sp" colspan="2">&nbsp;</td></tr>
        <tr><td class="lt">Issuer:</td><td class="rt"><?php echo $issuer; ?></td></tr>
        <tr><td class="lt">Serial (Last 12):</td><td class="rt"><?php echo $xserial; ?></td></tr>
        <tr><td class="lt">Cert Expires:</td><td class="rt"><?php echo $xcert['tbsCertificate']['validity']['notAfter']['utcTime']; ?></td></tr>
      </table>
      <div style="margin: 24px 0;">
        <a href="#"><i class="fa fa-id-badge"></i></a> 
        <a href="#"><i class="fa fa-ioxhost"></i></a>  
        <a href="#"><i class="fa fa-envelope"></i></a>  
        <a href="#"><i class="fa fa-info-circle"></i></a> 
      </div>
      <img src="./img/a2020x.png" alt="F5 Agility 2020" style="width:100%">
    </div><br><br><br>
    <button onclick="changeStatus()">Expand Certificate Data Array</button>
    <div id="status" class="array">
      <?php
        echo "<h1>Certificate Information (Array Format)</h1>";
        print("<pre>".print_r($xcert,true)."</pre>"); 
      ?>      
    </div> 
  </body>
</html>

