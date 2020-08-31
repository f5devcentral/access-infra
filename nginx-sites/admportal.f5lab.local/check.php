<?php
  if (isset($_GET['repo'])) { 
    $repo = strtolower($_GET['repo']);
    $inc_loc = "./env-".$repo.".inc";
    include($inc_loc);
    echo $version;
  } else {
    echo "NO DATA";
  }
?>