<?php
  //  Primary Functions 
  function sitename() {
    $host=explode(".", $_SERVER['HTTP_HOST']);
    $portal['host']=strtolower($host[0]);
    $portal['fqdn']=strtolower($_SERVER['HTTP_HOST']);
    switch ($portal['fqdn']) {
      case "portal.f5lab.local":
        $portal['branch']="master";
        break;
      case "devportal.f5lab.local":
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

  function checkRepo ($repo) {
    $output = shell_exec('git ls-remote '.$repo);
    return $output;
  }

  function nameRepo ($repo, $branch) {
    $repo_parse = explode('/', $repo);
    $name = $repo_parse[3].'_'.$repo_parse[4].'_'.$branch;
    return $name;
  }

  function getRepo ($repo, $branch) {
    include('./env.inc');
    $cmd1= "cd ".$customloc;
    $folder = nameRepo($repo, $branch);
    $cmd2='git clone -b '.$branch.' --single-branch '.$repo.' '.$folder;
    $output = shell_exec($cmd1." && ".$cmd2);
    return $output;
  }

  function createCron ($repo, $branch) {
    include('./env.inc');
    $name = nameRepo($repo, $branch); 
    $file = $cronloc.$name."-pull";
    $current = file_get_contents($file) ;
    $current .= "#!/bin/sh\ncd ".$customloc.$name."\ngit pull -q origin ".$branch."\n";
    file_put_contents($file, $current);
    shell_exec("chmod 655 ".$file);
  }

  function findContent($type, $dir) {
    $result = array();
    $ignored = array('.', '..', '.git');
    $cdir = scandir($dir);
    foreach ($cdir as $key => $value) {
      if (!in_array($value,$ignored)) {
        if ( (is_dir($dir . DIRECTORY_SEPARATOR . $value)) && (startsWith($value, $type)) ){
          $result[] = $value;
        }
      }
    }
    return $result;
  }

  function findCustomRepo($dir) {
    $result = array();
    $ignored = array('.', '..', '.git');
    $cdir = scandir($dir);
    foreach ($cdir as $key => $value) {
      if (!in_array($value,$ignored)) {
        if ( (is_dir($dir . DIRECTORY_SEPARATOR . $value)) ){
          $result[$value]['branch']=getCustomRepoData($dir,$value);
          $result[$value]['modified']=date ("F d Y H:i:s.", filemtime($dir . DIRECTORY_SEPARATOR . $value));
        }
      }
    }
    return $result;
  }

  function findLaunch($dir) {
    $ignored = array('.', '..', '.git');
    $cdir = scandir($dir);
    foreach ($cdir as $key => $value) {
      if (!in_array($value,$ignored)) {
        if ( (is_dir($dir . DIRECTORY_SEPARATOR . $value)) && ($value=="ansible") ) {
          $result = $value;
        } else {
          $result = "postman";
        }
      }
    }
    return $result;
  }

  function getCustomRepoData($dir,$value) {
    $head_file = $dir."/".$value."/.git/HEAD";
    $lines = file($head_file);
    $output = substr($lines[0], 16);  // branch
    return $output;
  }

  function getFileData($type, $dir) {
    $file_data=findContent($type, $dir);
	natsort($file_data);
    foreach ($file_data as $key => $value) {
      $rst_file = $dir."/".$value."/".$type.".rst";
      $lines = file($rst_file);
      $output[$value]['num'] = $value;                // number
      $output[$value]['title'] = substr($lines[0],strpos($lines[0], ':')+2);  // title
      $output[$value]['descr'] = $lines[3];             // description
      $kw_match=array_values(preg_grep('/^Keywords:[^\r\n]*/m', $lines));	  
      $output[$value]['keywords'] = substr($kw_match[0],10);  // keywords
      $dc_match=array_values(preg_grep('/^DC:[^\r\n]*/m', $lines));	  
      $output[$value]['type'] = substr($dc_match[0],4);   // type (single/multi)
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

  function launchtile($branch,$page,$num,$title,$descr,$type) {
    echo "<div class='col-1-4'><div class='portfolio-box'><div class='portfolio-box-img'>";
    echo "<img src='./image.php?title=".$title."' width='95%' class='img-responsive' alt=''><p class='portfolio-box-p'>".ucfirst($num)."</p></div>";
    echo "<div class='portfolio-box-caption' style='background:rgba(45, 154, 225,.9);'><div class='portfolio-box-caption-content'>";
    echo "<div class='project-des'><p>".$descr."</p></div><div class='project-social'>";
    echo "<table width='100%' style='padding: 0; border:0px;'>";
    if (strstr($type, 'multi') === false) {
      echo "<tr style='padding: 0; border:0px;'><td width='100%'>Single DC</td></tr>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./index.php?page=launch&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launch&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=delete'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } else { 
      echo "<tr style='padding: 0; border:0px;'><td width='50%'>Single DC</td><td colspan='2'width='50%'>Multi DC</td></tr>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./index.php?page=launch&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launch&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=delete'><i class='fa fa-stop'></i></a></li></ul></td>";
      echo "<td><ul class='list-inline'><li><a href='./index.php?page=launch&branch=".$branch."&repo=".$page."&resource=".$num."&mode=multi&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launch&branch=".$branch."&repo=".$page."&resource=".$num."&mode=multi&action=delete'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } 
    echo "</table>";
    echo "</div></div></div></div></div>";
  }
?>