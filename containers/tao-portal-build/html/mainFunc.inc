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

  function endsWith($string, $endString) { 
    $len = strlen($endString); 
    if ( !$len ) {
      return true;
    }
    return (substr($string, -$len) === $endString); 
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

  function findLabContent($type, $dir) {
    $ignored = array('.', '..', '.git', '.gitignore', 'index.rst', 'intro.rst');
    $clisting = scandir($dir);
    $alllabs = array();
    foreach ($clisting as $key => $cvalue) {
      if (!in_array($cvalue,$ignored)) {
        if ( (is_dir($dir . DIRECTORY_SEPARATOR . $cvalue)) && (startsWith($cvalue, "class")) ) {
          $crst_file = $dir.$cvalue."/".$cvalue.".rst";
          $clines = file($crst_file);
          $seriesnum = substr($clines[0],0,3);  // series
          $series[$seriesnum]['designation'] = $cvalue;  // class value
          $series[$seriesnum]['title'] = substr($clines[0],strpos($clines[0], ':')+2);  // title
          $series[$seriesnum]['description'] = $clines[3];  // description
          $x = count($clines);
          for ($i = 4; $i <= $x; $i++) {
            $line = trim($clines[$i]);
            if ( is_numeric(substr($line, 0, 1)) ) {
              $classnum = substr($line,0,3);  // series
              $title = substr($line,strpos($line, '-')+2);  // title
              $cflag = 0;
            } else {
              if ( startsWith($line, ":caption") ) {
                $endtrim = -1 * (strlen($line) - strpos($line, "Labs:") +1);
                $version = substr($line, 18, $endtrim);  // version
                $cflag = 1;
              } 
              if ( (startsWith($line, "module")) && (endsWith($line, ".rst")) ) {
                $module = substr($line,0,strpos($line, '/'));  // module
                if ( $cflag == 1 ) {
                  $classes[$module]['classnum'] = $classnum."-v".$version;
                  $classes[$module]['title'] = $title;
                  $cflag == 0;
                } else {
                  $classes[$module]['classnum'] = $classnum;
                  $classes[$module]['title'] = $title;
                }
              }
            }
          }
          $mdir = $dir.$cvalue."/";
          $mlisting = scandir($mdir);
          foreach ($mlisting as $key => $mvalue) {
            if (!in_array($mvalue,$ignored)) {
              if ( (is_dir($mdir . DIRECTORY_SEPARATOR . $mvalue)) && (startsWith($mvalue, "module")) ) {
                $labs = array();
                $ldir = $dir.$cvalue."/".$mvalue."/";
                $llisting = scandir($ldir);
                foreach ($llisting as $key => $lvalue) {
                  if (!in_array($lvalue,$ignored)) {
                    if ( (startsWith($lvalue, "lab")) && (endsWith($lvalue, ".rst")) ) {
                      $labnum = ucfirst(substr($lvalue,0,-4));
                      $labs[$classes[$mvalue]['classnum']."-".$labnum]['file'] = $lvalue;
                      $lrst_file = $mdir."/".$mvalue."/".$lvalue;
                      $llines = file($lrst_file);
                      $labs[$classes[$mvalue]['classnum']."-".$labnum]['title'] = substr($llines[0],strpos($llines[0], ':')+2);  // title
                      $pfile = $dir.$cvalue."/".$mvalue."/postman/".$cvalue."-".$mvalue."-".strtolower($labnum)."-create.postman_collection.json";
                      if (file_exists($pfile)) {
                        $labs[$classes[$mvalue]['classnum']."-".$labnum]['postman'] = "y";
                      } else {
                        $labs[$classes[$mvalue]['classnum']."-".$labnum]['postman'] = "n";
                      }
                      $alllabs[$classes[$mvalue]['classnum']."-".$labnum]['title'] = substr($llines[0],strpos($llines[0], ':')+2);  // title
                      $alllabs[$classes[$mvalue]['classnum']."-".$labnum]['postman'] = $labs[$classes[$mvalue]['classnum']."-".$labnum]['postman'];  // postman
                    }
                  }
                }
                $series[$seriesnum][$classes[$mvalue]['classnum']]['designation']=$mvalue;
                $series[$seriesnum][$classes[$mvalue]['classnum']]['title']=$classes[$mvalue]['title'];
                $series[$seriesnum][$classes[$mvalue]['classnum']]['labs']=$labs;
              }
            }
          }
        }
      }
    }
    switch ($type) {
      case "class":
        return $series;
        break;
      case "lab":
        return $alllabs;
        break;
    }
  }

  function findSolContent($type, $dir) {
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

  function findClassContent($type, $dir) {
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

  function getSolData($type, $dir) {
    $file_data=findSolContent($type, $dir);
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

  function getLabData($type, $dir) {
    $file_data=findLabContent($type, $dir);
    ksort($file_data);
    foreach ($file_data as $key => $value) {
      $output[$key]= $value;
    }
    return $output;
  }

  function getClassData($type, $dir) {
    $file_data=findLabContent($type, $dir);
//    natsort($file_data);
//    foreach ($file_data as $key => $value) {
//      $rst_file = $dir."/".$value."/".$type.".rst";
//      $lines = file($rst_file);
//      $output[$value]['num'] = $value;                // number
//      $output[$value]['title'] = substr($lines[0],strpos($lines[0], ':')+2);  // title
//      $output[$value]['descr'] = $lines[3];             // description
//      $kw_match=array_values(preg_grep('/^Keywords:[^\r\n]*/m', $lines));	  
//      $output[$value]['keywords'] = substr($kw_match[0],10);  // keywords
//      $dc_match=array_values(preg_grep('/^DC:[^\r\n]*/m', $lines));	  
//      $output[$value]['type'] = substr($dc_match[0],4);   // type (single/multi)
//    }
    return $file_data;
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

  function launchsoltile($branch,$page,$num,$title,$descr,$type) {
    echo "<div class='col-1-4'><div class='portfolio-box'><div class='portfolio-box-img'>";
    echo "<img src='./image.php?title=".$title."' width='95%' class='img-responsive' alt=''><p class='portfolio-box-p'>".ucfirst($num)."</p></div>";
    echo "<div class='portfolio-box-caption' style='background:rgba(45, 154, 225,.9);'><div class='portfolio-box-caption-content'>";
    echo "<div class='project-des'><p>".$descr."</p></div><div class='project-social'>";
    echo "<table width='100%' style='padding: 0; border:0px;'>";
    if (strstr($type, 'multi') === false) {
      echo "<tr style='padding: 0; border:0px;'><td width='100%'>Single DC</td></tr>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./index.php?page=launchsol&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launchsol&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=delete'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } else { 
      echo "<tr style='padding: 0; border:0px;'><td width='50%'>Single DC</td><td colspan='2'width='50%'>Multi DC</td></tr>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./index.php?page=launchsol&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launchsol&branch=".$branch."&repo=".$page."&resource=".$num."&mode=single&action=delete'><i class='fa fa-stop'></i></a></li></ul></td>";
      echo "<td><ul class='list-inline'><li><a href='./index.php?page=launchsol&branch=".$branch."&repo=".$page."&resource=".$num."&mode=multi&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launchsol&branch=".$branch."&repo=".$page."&resource=".$num."&mode=multi&action=delete'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } 
    echo "</table>";
    echo "</div></div></div></div></div>";
  }

  function launchlabtile($branch,$labnum,$title,$type) {
    echo "<div class='col-1-4'><div class='portfolio-box'><div class='portfolio-box-img'>";
    echo "<img src='./image.php?title=".$title."' width='95%' class='img-responsive' alt=''><p class='portfolio-box-p'>".ucfirst($labnum)."</p></div>";
    if (strstr($type, 'y') === false) {
      echo "<div class='portfolio-box-caption' style='background:rgba(171, 183, 183, 1);'><div class='portfolio-box-caption-content'>";
      echo "<div class='project-des'><p>Refer to Lab01 of this Class or Lab series for setup instructions. If this is Lab01, there are no setup requirements.</p></div><div class='project-social'>";
      echo "<table width='100%' style='padding: 0; border:0px;'>";
    } else { 
      echo "<div class='portfolio-box-caption' style='background:rgba(45, 154, 225,.9);'><div class='portfolio-box-caption-content'>";
      echo "<div class='project-des'><p>Create or Delete initial setup for this lab environment with the buttons below.</p></div><div class='project-social'>";
      echo "<table width='100%' style='padding: 0; border:0px;'>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./index.php?page=launchlab&branch=".$branch."&class=".$class."&module=".$module."&repo=lab&resource=".$labnum."&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launchlab&branch=".$branch."&class=".$class."&module=".$module."&repo=lab&resource=".$labnum."&action=delete'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } 
    echo "</table>";
    echo "</div></div></div></div></div>";
  }

  function launchclasstile($branch,$class,$module,$num,$title,$type) {
    $lab = explode("lab", strtolower($num));
    $labnum = "lab".$lab[1]; 
    echo "<div class='col-1-4'><div class='portfolio-box'><div class='portfolio-box-img'>";
    echo "<img src='./image.php?title=".$title."' width='95%' class='img-responsive' alt=''><p class='portfolio-box-p'>".ucfirst($num)."</p></div>";
    if (strstr($type, 'y') === false) {
      echo "<div class='portfolio-box-caption' style='background:rgba(171, 183, 183, 1);'><div class='portfolio-box-caption-content'>";
      echo "<div class='project-des'><p>Refer to Lab01 of this Class or Lab series for setup instructions. If this is Lab01, there are no setup requirements.</p></div><div class='project-social'>";
      echo "<table width='100%' style='padding: 0; border:0px;'>";
    } else { 
      echo "<div class='portfolio-box-caption' style='background:rgba(45, 154, 225,.9);'><div class='portfolio-box-caption-content'>";
      echo "<div class='project-des'><p>Create or Delete initial setup for this lab environment with the buttons below.</p></div><div class='project-social'>";
      echo "<table width='100%' style='padding: 0; border:0px;'>";
      echo "<tr style='padding: 0; border:0px;'><td><ul class='list-inline'><li><a href='./index.php?page=launchlab&branch=".$branch."&class=".$class."&module=".$module."&repo=lab&resource=".$labnum."&action=create'><i class='fa fa-play'></i></a></li><li><a href='./index.php?page=launchlab&branch=".$branch."&class=".$class."&module=".$module."&repo=lab&resource=".$labnum."&action=delete'><i class='fa fa-stop'></i></a></li></ul></td></tr>";
    } 
    echo "</table>";
    echo "</div></div></div></div></div>";
  }

?>