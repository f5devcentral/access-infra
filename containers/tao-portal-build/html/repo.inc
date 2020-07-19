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
                <div class="intro">Add Custom Contribution Repo to the UDF Deployment</div>
                <hr class="line-b">
                <div class="lead">Adding repo and associated branch (defaults to master) will retrieve remote custom repo and add to the local UDF deployment.<br>It will also add it to the local system git/crontab services for continual updates.</div>
              </div>
            </div>
            <div class="row">
              <div class="wrapper">
                <form method="post" action="">Retrieve Remote Repository: <input id="repoinput" type="text" name="repo" placeholder="Enter repo location (full URL)">:<input id="repobranch" type="text" name="branch" placeholder="master">&nbsp;&nbsp;<input id="repobutton" type="submit" name="submit" value="Add"></form>
                <?php
                  if ( (isset($_GET['error'])) && ($_GET['error'] == '1') ) { echo "<font color='red'>Repository not found or entered in error.</font>"; }
                ?>
                <br><br>  
                <div class="intro" style="font-size:18px;">Current Custom Repos</div>
                <hr class="line-b">
                <div class="lead">Custom repo can be accessed in the files paths denoted below.</div>
                <?php
                  echo "<table id='repo' width='100%'><tr><th>Custom Repository</th><th>Branch</th><th>URL Location</th><th>File Location</th><th>Last Updated</th><th>Action</th></tr>";
                  $data=findCustomRepo($customloc);
                    foreach ($data as $key => $value) {
                      echo "<tr><td>".$key."</td><td>".$data[$key]['branch']."</td><td><a href='".$filesdevurl."'>".$filesdevurl."</a></td><td>".$customloc.$key."</a></td><td>".$data[$key]['modified']."</td><td><form method='post' action=''><input type='hidden' name='rm_repo' value='".$key."'><input id='repobutton' type='submit' name='submit' value='Delete'></form></tr>";
                    }
                  echo "</table>";
                ?>
              </div>
            </div>
          </div>
        </div>
      </section>
    <!-----------------end-content-box--------------------->
  <?php
    } else {
      switch ($_POST['submit']) {
        case "Add":
          $output=checkRepo($_POST['repo']);
          if ($output != "") {
            if ( (!(isset($_POST['branch']))) or ($_POST['branch']=="") ) { 
              $branch = "master";
            } else {
              $branch = $_POST['branch'];
            }
            $reporesult=getRepo($_POST['repo'],$branch);
			createCron($_POST['repo'],$branch);
            header('Location: /index.php?page=repo');
          } else {
            header('Location: /index.php?page=repo&error=1');
          }
          break;
        case "Delete":
          $cmd1 = "rm -rf ".$customloc.$_POST['rm_repo'];
          $cmd2 = "rm -rf ".$cronloc..$_POST['rm_repo']."-pull";
          shell_exec($cmd2);
          shell_exec($cmd1);
          header('Location: /index.php?page=repo');
          break;
      }
    }
  ?>
