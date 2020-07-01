<?php
#******************************************************
#          Set & verify DB Connection
#******************************************************
  include 'netDB.inc';
  $_SESSION['link'] = new mysqli($DBhost, $DBuser, $DBpass, $DBname);
  if(mysqli_connect_errno()) {
    header('location: index.php?ce='.mysqli_connect_errno());
  } 


#******************************************************
#          Portal Elements
#******************************************************
function portalHeader() {
  echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">";
  echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>";
  echo "<head><title>ACME Portal</title>";
  echo "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>";
  echo "<meta http-equiv='X-UA-Compatible' content='IE=edge' /> <!-- Make IE play nice -->";
  echo "<meta name='viewport' content='width=device-width, user-scalable=yes'/>";
  echo "<link rel='stylesheet' href='./main.css'></head>";
}

function portalEnd() {
  echo "</html>";
}

#******************************************************
#          Page Elements
#******************************************************
function pageHeader() {
  echo "<div class='header'>";
  echo "<div class='header-content'>";
  echo "<div class='header-image'><img src='./img/spy2.png' height='75px'></div>";
  echo "<div class='header-title'>ACME Portal</div>";
  echo "<div class='header-subtitle'>Resource Dashboard</div>";
  echo "</div></div>";
}

function pageNavbar() {
  echo "<nav><ul>";
  echo "<li><a href='./main.php?page=home' id='short'>Home</a></li>";

  $nresult=$_SESSION['link']->query("SELECT * FROM category ORDER BY id ASC");
  while ($navlist=$nresult->fetch_assoc()) {
    echo "<li><a href='#'>".$navlist['c_name']."</a><ul>";
    $snresult=$_SESSION['link']->query("SELECT * FROM subcategory WHERE cat_id=".$navlist['id']." ORDER BY sc_name ASC");
    while ($snavlist=$snresult->fetch_assoc()) {
      echo "<li><a href='./main.php?cat=".$navlist['c_name']."&sub=".$snavlist['sc_name']."'>".$snavlist['sc_name']."</a></li>";
    }
    echo "</ul></li>";
  }
  echo "<li><a href='./logoff.php' id='short'>Logoff</a></li>";
  echo "</ul></nav>";
}

function breadCrumb($cat,$sub) {
  echo "<div id='content-title'>".$cat;
  if ($sub!='none') {
    echo " > ".$sub;
  }
  echo "</div>";
}

function catsub_id($cat,$sub) {
  $xresult=$_SESSION['link']->query("SELECT category.id AS c_id,subcategory.id AS sc_id FROM category,subcategory WHERE category.c_name='".$cat."' && subcategory.sc_name='".$sub."'");
  $xid=$xresult->fetch_assoc();
  return $xid;
}


function pageData($cat,$sub) {
  $xid=catsub_id($cat,$sub);
  $tresult=$_SESSION['link']->query("SELECT asset.a_name AS a_name, asset.suffix AS a_suffix ,asset.description AS a_desc, asset.ip AS a_ip, asset.zone AS a_zone, vendor.name AS v_name FROM asset,vendor where cat_id='".$xid['c_id']."' &&  subcat_id='".$xid['sc_id']."' && vendor.id=asset.vendor_id");
  while ($tlist=$tresult->fetch_assoc()) {
    echo "<tr>";
    echo "<td><label for='toggle-".strtolower($tlist['v_name'])."'><img class='".$tlist['v_name']."' src='./img/logo_".strtolower($tlist['v_name']).".png'/></label></td>";
    echo "<td><label for='toggle".$t."'><b>".$tlist['a_name']."</b>.".$tlist['a_suffix']."</label></td>";
    echo "<td>".$tlist['a_desc']."</td>";
    echo "<td>".$tlist['a_ip']."</td>";
    echo "<td>".$tlist['a_zone']."</td>";
    echo "<td>Remote</td>";
    echo "<td><img class='status' src='./img/status_green.png' /></td>";
    echo "</tr>";
  }
}


function linklist($cat,$sub) {
  $xid=catsub_id($cat,$sub);
  $lresult=$_SESSION['link']->query("SELECT description,link_url FROM links where cat_id='".$xid['c_id']."' &&  subcat_id='".$xid['sc_id']."' ORDER BY description");
  echo "<div id='mainContent'>";
  echo "<table class='container'>";
  echo "<tr>";
  echo "<td class='left' valign='top'>";
  echo "<table id='box-table-a'>";
  echo "<thead><tr>";
  echo "<th width='29%'>Description</th>";
  echo "<th width='1%'>&nbsp;</th>";
  echo "<th width='70%'>Link</th>";
  echo "</tr></thead>";
  echo "<tbody>";
  while ($llist=$lresult->fetch_assoc()) {
    echo "<tr><td style='text-align:right'>".$llist['description'].":</td><td>&nbsp;</td><td style='text-align:left'><a href='".$llist['link_url']."'>".$llist['link_url']."</a></td></tr>";
  }
  echo "</tbody>";
  echo "</table>";
  echo "</td>";
  echo "<td class='right' valign='top'>";
  echo "<div id='content5'>Static Information</div>";
  echo "</td>";
  echo "</tr>";
  echo "</table>";
  echo "</div>";
}

function custinfo($cat,$sub,$c_page) {
  $xid=catsub_id($cat,$sub);
  if (!$c_page) {$c_page=1;};
  $c_start=($c_page-1)*20;

  $rresult=$_SESSION['link']->query("SELECT * FROM customers where sc_id='".$xid['sc_id']."'");
  $cresult=$_SESSION['link']->query("SELECT cust_name,abbr FROM customers where sc_id='".$xid['sc_id']."' ORDER BY cust_name LIMIT ".$c_start.",20");
  $rowcount=mysqli_num_rows($rresult);
  $c_end=intval($rowcount/20)+1;
  echo "<div id='mainContent'>";
  echo "<table class='container'>";
  echo "<tr>";
  echo "<td valign='top' width='35%'>";
  echo "<table id='box-table-a'>";
  echo "<thead><tr>";
  echo "<th width='10%'>#</th>";
  echo "<th width='90%'>Customer</th>";
  echo "</tr></thead>";
  echo "<tbody  width='40%'>";
  $c_cnt=$c_start+1;
  while ($clist=$cresult->fetch_assoc()) {
    echo "<tr><td style='text-align:center'>".$c_cnt."</td><td style='text-align:center'>".$clist['cust_name']."</td></tr>";
    $c_cnt++;
  }
  echo "</tbody>";
  echo "</table>";
  echo "</td>";
  echo "<td valign='top' width='60%'>";
  echo "<div id='content-custinfo'>Static Information</div>";
  echo "</td>";
  echo "</tr>";
  echo "</table>";
  $rowcount=mysqli_num_rows($rresult);
  if ($rowcount > 20 ) {
    $n_page=$c_page+1;
    if ($c_page > 1 ) { 
      $l_page=$c_page-1;
    } else {
      $l_page=$c_page;      
    }
    echo "<div style='text-align:center'>";
    echo "<a href='./main.php?cat=".$cat."&sub=".$sub."&c_page=".$l_page."'><img src='./img/back1.png' width='50'></a>";
    if ($n_page <= $c_end) {
      echo "&nbsp;&nbsp;&nbsp;&nbsp;<a href='./main.php?cat=".$cat."&sub=".$sub."&c_page=".$n_page."'><img src='./img/forward1.png' width='50'></a>";      
    }
    echo "</div>";
  }
  echo "</div>";
}

#******************************************************
#          LDAP Functions
#******************************************************
function valBind($ldapuid,$ldappass) {
  $ldaphost="127.0.0.1";
  $ldapport=389;
  $ldapconn=ldap_connect($ldaphost,$ldapport)
  or die("Could not connect to LDAP server.");

  ### OpenLDAP UID Modification
  $ldapuid="uid=".$ldapuid.",ou=users,dc=acme,dc=com";

  ### With validated ldapconn, begin Bind
  if ($ldapconn) {
    ldap_set_option($ldapconn, LDAP_OPT_PROTOCOL_VERSION, 3);
    ldap_set_option($ldapconn, LDAP_OPT_REFERRALS, 0);
    $ldapbind=ldap_bind($ldapconn, $ldapuid, $ldappass);
    ### Validate Bind
    if ($ldapbind) {
      $bind=1;
    } else {
      $bind=0;
    }
  }
  ldap_close($ldapconn); 

  ### Return Results
  return $bind;
}

?>
