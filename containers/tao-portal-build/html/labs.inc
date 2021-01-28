<!--#### CONTENT ##### -->

<!-----------------start-content-box------------------->
  <section class="content-box box-4">
    <div class="zerogrid" style="width: 100%;">
      <div class="row wrap-box">
        <div class="zerogrid-b">
          <div class="header">
            <div class="wrapper">
              <div class="intro">Available <?php echo ucfirst($page)."s"; ?><span style="font-size:.6em"> (Provided through <a class='repo' href='https://github.com/f5devcentral' target='_blank'>F5DevCentral Github Repo</a>)</span></div>
              <hr class="line-b">
              <p>Hover over the desired <?php echo $page; ?> and use the "Play" or "Stop" icons to create or delete a <?php echo $page; ?>. NOTE: In order for Multi DataCenter <?php echo $page; ?>s to function, all BIG-IP's in the <?php echo $page; ?> environment must be started. 
            </div>
          </div>
        </div>
<?php
  $fileloc=$webloc.$portal['branch']."/".$page."s/";
  $data=getLabData($page, $fileloc);
  echo "<div class='row'>";
  if ( (isset($_GET['filter'])) && ($_GET['filter'] != '') ) {
    foreach ($data as $key => $row) {
      if (strstr(strtolower($row['title']), strtolower($_GET['filter'])) !== false) {
       launchlabtile($portal['branch'],$key,urlencode($row['title']),$row['postman']);
      }
   }
  } else {
    foreach ($data as $key => $row) {
      launchlabtile($portal['branch'],$key,urlencode($row['title']),$row['postman']);
    }
  }
  echo "</div>";
?>
      </div>
    </div>
  </section>
<!-----------------end-content-box------------------->
