<!--#### LAUNCH ##### -->
<?php 
  $branch = $_GET['branch'];
  $class = $_GET['class'];
  $module = $_GET['module'];
  $resource = $_GET['resource'];
  $action = $_GET['action'];

?>
<!-----------------start-content-box------------------->
 
  <div id="load"></div>
  <div id="contents">
  <section class="content-box box-4">
    <div class="zerogrid" style="width: 100%;">
      <div class="row wrap-box">
        <div class="zerogrid-b">
          <div class="header" style="margin-left: 40px;">
            <div class="wrapper">
              <div class="intro">Processing Postman/Newman Scripts<span style="font-size:.6em"> (Provided through <a class='repo' href='https://github.com/f5devcentral' target='_blank'>F5DevCentral Github Repo</a>)</span></div>
              <hr class="line-b">
            </div>
          </div>
        </div>
        <div class='zerogrid' width='80%' style='background:#000000; color:#00FF00;'>
<?php
  $cmd = "newman run ".$webloc.$branch."/labs/".$class."/".$module."/postman/".$class."-".$module."-".$resource."-".$action.".postman_collection.json -e ".$webloc.$branch."/labs/".$class."/".$module."/postman/".$branch."-single-dc.postman_environment.json -k";

  while (@ ob_end_flush()); // end all output buffers if any
  $proc = popen($cmd, 'r');
  echo '<pre>';
  while (!feof($proc)) {
    echo fread($proc, 4096);
    @ flush();
  }
  echo '</pre>';
//  echo $cmd;

?>
      </div>
     <div class='zerogrid' width='80%'>
      <br>
      <span style="font-size:1.2em"><a class='repo' href='./index.php?page=class'>Return to Classes Portal</a></span>
    </div>
      </div>
    </div>
  </section>
  </div>
<!-----------------end-content-box------------------->
