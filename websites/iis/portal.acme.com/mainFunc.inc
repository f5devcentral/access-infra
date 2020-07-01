<?php

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

#******************************************************
#          LDAP Functions
#******************************************************
function valBind($ldapuid,$ldappass) {
  $ldaphost="192.168.69.187";
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
