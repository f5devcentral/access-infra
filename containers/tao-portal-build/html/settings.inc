<!--#### CONTENT ##### -->
  <?php
    if ( !(isset($_POST['submit'])) ) {
  ?>
  <!-----------------start-content-box-------------------->
    <section class="content-box boxstyle-2 box-3">
      <div class="zerogrid">
        <div class="row wrap-box">
          <div class="header2">
            <div class="wrapper">
              <div class="intro">Updating Portal/DevPortal Container</div>
              <hr class="line-b">
              <div class="lead">Using the "Redeploy" buttons from the table below will redeploy the Portal/Devportal container updating it to the latest code version. <br>Either the DEV or MASTER branch of the Portal/Devportal code can be selected. The branch selected will update <b><u>BOTH</u></b> the Portal/Devportal interfaces.<br><i><b>NOTE</b>: Custom repositories will <b><u>NOT</u></b> survive the redeployment as the container is ephemeral and will need to be re-added if necessary.</i><br><br><i><b>NOTE</b>: Updates will take a few seconds.</i></div><br>
                <table id='repo' width='100%'><tr><th>Current Portal/Devportal Version</th><th>Branch Source</th><th>Version Available</th><th>Action</th></tr>
                  <?php 
                    $master_ver = shell_exec('curl http://admportal.f5lab.local/check.php?repo=master');
                    $dev_ver = shell_exec('curl http://admportal.f5lab.local/check.php?repo=dev');
                    echo "<tr><td rowspan='2' style='text-align: center; vertical-align: middle; font-size:1.4em;'>v".$version."</td><td>Master</td><td>v".$master_ver."</td><td><a href='http://admportal.f5lab.local/redeploy.php?repo=master&portal=".$portal['host']."'><input id='repobutton' type='submit' name='submit' value='Redeploy'></a></tr>";
                    echo "<tr><td>Dev</td><td>v".$dev_ver."</td><td><a href='http://admportal.f5lab.local/redeploy.php?repo=dev&portal=".$portal['host']."'><input id='repobutton' type='submit' name='submit' value='Redeploy'></a></tr>";
                  ?>
                </table>
            </div>
          </div>
          <div class="header2">
            <div class="wrapper">
              <div class="intro">Control Git Auto-Updating (Pull) Functionality</div>
              <hr class="line-b">
              <div class="lead">The following toggles (enable/disable) the Git scripted cron jobs used for auto-updating the Access Labs & Solutions Repositories (master & dev) within this deployment/blueprint.</div>
            </div>
          </div>
          <div class="row">
            <div class="wrapper">
              <form method="post" action="">
              <?php 
                $cron_dir = scandir($cronloc);
                foreach ($cron_jobs as $value) {
                  $target = explode("-", substr($value,15));
                  if (in_array($value,$cron_dir)) {
                    echo "<div style='float:left; width:60%;'>Auto-Update for Access-Infra/".$target[0].":".$target[1]." Repository: </div><div style='float:left; width:40%;'><label class='switch'><input name='".$value."' class='switch-input' type='checkbox' checked/><span class='switch-label' data-on='Enabled' data-off='Disabled'></span><span class='switch-handle'></span><br></label></div>";
                  } else {
                    echo "<div style='float:left; width:60%;'>Auto-Update for Access-Infra/".$target[0].":".$target[1]." Repository: </div><div style='float:left; width:40%;'><label class='switch'><input name='".$value."' class='switch-input' type='checkbox'/><span class='switch-label' data-on='Enabled' data-off='Disabled'></span><span class='switch-handle'></span><br></label></div>";
                  }
                }
              ?>
              <div style='width:70%; text-align:center'><input id='repobutton' type='submit' name='submit' value='Update'></div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </section>
  <!-----------------end-content-box--------------------->
  <?php
    } else {
      switch ($_POST['submit']) {
        case "Update":
          $cron_1min = scandir($cronloc);
          $cron_hold = scandir($cronholdloc);
          foreach ($cron_jobs as $value) {
            if ( !(array_key_exists($value,$_POST)) ) {
              if (in_array($value,$cron_1min)) {
                $cmd="mv ".$cronloc.$value." ".$cronholdloc.$value;
              }
            } else {
              if (in_array($value,$cron_hold)) {
                $cmd="mv ".$cronholdloc.$value." ".$cronloc.$value; 
              }
            } 
            shell_exec($cmd);
          }
          header('Location: /index.php?page=settings');
          break;
      }
    }
  ?>
