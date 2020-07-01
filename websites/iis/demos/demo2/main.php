<?php
session_start();
if(!isset($_SESSION['sid'])) {
  header("location: https://myapps.acme.com/mx/random/loginpage.php");
}
else {
  include './mainFunc.inc';
  $cat=$_GET['cat'];
  if(isset($_GET['sub'])) { 
    $sub=$_GET['sub']; 
  } else {
    $sub='none';
  }
  if(isset($_GET['c_page'])) { $c_page=$_GET['c_page']; }
  portalHeader();
?>

<body>
  <?php pageHeader(); ?>
  <div id="contentWrapper">
    <?php 
      pageNavbar();
      breadCrumb($cat,$sub);
      switch ($cat) {
        case "Modules":
          linklist ($cat,$sub);
          break;
        case "Platforms":
          break;
        case "Features":
          linklist ($cat,$sub);
          break;
        case "Security":
          break;
        case "Information":
          break;
        case "Customers":
          custinfo ($cat,$sub,$c_page);
          break;
        case "Partners":
          break;
        default:
          break; 
      }
    ?>
<!--    <div id="content6"><p class="tip">Tip test box</p></div>  -->
  </div>
  <div id="footer"></div>
</body>
<?php
  portalEnd();
}
?>
