<!DOCTYPE html>
<?php
  // Environment Setup 
  include('./env.inc');
  include('./mainFunc.inc');
  $portal=sitename();  // Sets array for hostname, fqdn & branch 
  $page = (isset($_GET['page']) ? $_GET['page'] : 'solution');

  // Head Tag Information
  include('./headtag.inc');

  // Page Body
  echo "<body class='home-page'><div class='wrap-body'>";
  include('./pageheader.inc');
  echo "<section id='container'><div class='wrap-container'>";
  switch ($page) {
    case "lab":
      include('./labs.inc');
      break;
    case "solution":
      include('./solutions.inc');
      break;
    case "launch":
      include('./launch.inc');
      break;
    case "class":
      include('./classes.inc');
      break;
    case "repo":
      include('./repo.inc');
      break;
    case "settings":
      include('./settings.inc');
      break;
    default:
      $page='solution';
      include('./content.inc');
  }  
  echo "<br></div></section>";

  // Footer
  include('./pagefooter.inc');
  echo "</div></body></html>";
?>
