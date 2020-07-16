<!--#### LAUNCH ##### -->
<?php 
  $branch = $_GET['branch'];
  $repo = $_GET['repo'];
  $mode = $_GET['mode'];
  $resource = $_GET['resource'];
  $action = $_GET['action'];
  $launch = findLaunch($webloc.$branch."/".$repo."s/".$resource);
?>
<!-----------------start-content-box------------------->

  <section class="content-box box-4">
    <div class="zerogrid" style="width: 100%;">
      <div class="row wrap-box">
        <div class="zerogrid-b">
          <div class="header">
            <div class="wrapper">
              <div class="intro">Processing Postman/Newman Scripts<span style="font-size:.6em"> (Provided through <a class='repo' href='https://github.com/teamaccessonline' target='_blank'>Access Github Repo</a>)</span></div>
              <hr class="line-b">
            </div>
          </div>
        </div>
        <div class='zerogrid' width='80%' style='background:#000000; color:#00FF00;'>
<?php
  switch ($launch) {
    case "ansible":
      $cmd = "ansible-playbook ".$webloc.$branch."/".$repo."s/".$resource."/".$launch."/".$resource."-".$action.".".$launch."-".$mode."-dc-playbook.yml";
      break;
    case "postman":
      $cmd = "newman run ".$webloc.$branch."/".$repo."s/".$resource."/".$launch."/".$resource."-".$action.".".$launch."_collection.json -e ".$webloc.$branch."/".$repo."s/".$resource."/".$launch."/".$branch."-".$mode."-dc.".$launch."_environment.json -k";
      break;
  } 

  while (@ ob_end_flush()); // end all output buffers if any
  $proc = popen($cmd, 'r');
  echo '<pre>';
  while (!feof($proc)) {
    echo fread($proc, 4096);
    @ flush();
  }
  echo '</pre>';
?>
      </div>
     <div class='zerogrid' width='80%'>
      <br>
      <span style="font-size:1.2em"><a class='repo' href='./index.php?page=<?php echo $repo; ?>'>Return to <?php echo ucfirst($repo)."s"; ?> Portal</a></span>
    </div>
      </div>
    </div>
  </section>
<!-----------------end-content-box------------------->
