<!--#### CONTENT ##### -->
<!-----------------start-content-box------------------->
  <section class="content-box box-4">
    <div class="zerogrid" style="width: 100%;">
      <div class="row wrap-box">
        <div class="zerogrid-b">
          <div class="header">
            <div class="wrapper">
              <div class="intro">Available <?php echo ucfirst($page)."s"; ?><span style="font-size:.6em"> (Provided through <a class='repo' href='https://github.com/teamaccessonline' target='_blank'>TeamAccess Github Repo</a>)</span></div>
              <hr class="line-b">
              <p>Hover over the desired <?php echo $page; ?> and use the "Play" or "Stop" icons to create or delete a <?php echo $page; ?>.
            </div>
          </div>
        </div>
<?php
  $data=getFileData('solution', '/var/files');
  echo "<div class='row'>";
  if ( (isset($_GET['filter'])) && ($_GET['filter'] != '') ) {
    foreach ($data as $row) {
      if (strstr($row['keywords'], $_GET['filter']) !== false) {
       presobox($row['num'],urlencode($row['title']),$row['descr'],$row['keywords'],$row['type']);
      }
   }
  } else {
    foreach ($data as $row) {
      presobox($row['num'],urlencode($row['title']),$row['descr'],$row['keywords'],$row['type']);
    }
  }
  echo "</div>";
?>
      </div>
    </div>
  </section>
<!-----------------end-content-box------------------->
