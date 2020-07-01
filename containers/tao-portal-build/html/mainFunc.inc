<?php
  //  Primary Functions 
  function sitename() {
    $host=explode(".", $_SERVER['HTTP_HOST']);
    $portal['host']=strtolower($host[0]);
    $portal['fqdn']=strtolower($_SERVER['HTTP_HOST']);
    switch ($portal['fqdn']) {
      case "portal.f5lab.com":
        $portal['branch']="master";
        break;
      case "devportal.f5lab.com":
        $portal['branch']="dev";
        break;
      default:
        break;
    }
    return $portal;
  }
  
  function dirToArray($dir) {
    $result = array();
    $cdir = scandir($dir);
    foreach ($cdir as $key => $value) {
      if (!in_array($value,array(".",".."))) {
        if (is_dir($dir . DIRECTORY_SEPARATOR . $value)) {
          $result[$value] = dirToArray($dir . DIRECTORY_SEPARATOR . $value);
        } else {
          $result[] = $value;
        }
      }
    }
    return $result;
  }

  function startsWith($string, $startString) { 
    $len = strlen($startString); 
    return (substr($string, 0, $len) === $startString); 
  }

  function findContent($type, $dir) {
    $result = array();
    $cdir = scandir($dir);
    foreach ($cdir as $key => $value) {
      if (!in_array($value,array(".",".."))) {
        if ( (is_dir($dir . DIRECTORY_SEPARATOR . $value)) && (startsWith($value, $type)) ){
          $result[] = $value;
        }
      }
    }
    return $result;
  }

  function getFileData($type, $dir) {
    $file_data=findContent($type, $dir);
    foreach ($file_data as $key => $value) {
      $rst_file = $dir."/".$value."/".$type.".rst";
      $lines = file($rst_file);
      $output[$value]['num'] = $value;                // number
      $output[$value]['title'] = substr($lines[0],10);  // title
      $output[$value]['descr'] = $lines[3];             // description
      $output[$value]['keywords'] = substr($lines[5],10);  // keywords
      $output[$value]['type'] = substr($lines[7],4);   // type (single/multi)
    }
    return $output;
  }

  function srcbranch() {
    switch (strtolower($_SERVER['HTTP_HOST'])) {
      case "portal.f5lab.com":
        $result="master";
        break;
      case "devportal.f5lab.com":
        $result="dev";
        break;
      default:
        break;
    } 
    return $result;
  }

  function presobox($num,$title,$descr,$keywords,$type) {
    echo "<div class='col-1-4'><div class='portfolio-box'><div class='portfolio-box-img'>";
    echo "<img src='./image.php?title=".$title."' width='95%' class='img-responsive' alt=''><p class='portfolio-box-p'>".ucfirst($num)."</p></div>";
    echo "<div class='portfolio-box-caption' style='background:rgba(45, 154, 225,.9);'><div class='portfolio-box-caption-content'>";
    echo "<div class='project-des'><p>".$descr."</p></div><div class='project-social'>";
    echo "<table width='100%' style='padding: 0; border:0px;'>";
    if (strstr($type, 'multi') === false) {
      echo "<tr style='padding: 0; border:0px;'><td width='100%'>Single DC</td></tr>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./files/'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=request&req=".$qtr."'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } else { 
      echo "<tr style='padding: 0; border:0px;'><td width='50%'>Single DC</td><td colspan='2'width='50%'>Multi DC</td></tr>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./files/'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=request&req=".$qtr."'><i class='fa fa-stop'></i></a></li></ul></td>";
      echo "<td><ul class='list-inline'><li><a href='./files/' alt='Create Deployment'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=request&req=".$qtr."'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } 
    echo "</table>";
    echo "</div></div></div></div></div>";
  }
?>