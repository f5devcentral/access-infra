<!--#### CONTENT ##### -->

<!-----------------start-content-box------------------->
  <section class="content-box box-4">
    <div class="zerogrid" style="width: 100%;">
      <div class="row wrap-box">
        <div class="zerogrid-b">
          <div class="header">
            <div class="wrapper">
              <div class="intro">Available <?php echo ucfirst($page)."es"; ?><span style="font-size:.6em"> (Provided through <a class='repo' href='https://github.com/f5devcentral' target='_blank'>F5DevCentral Github Repo</a>)</span></div>
              <hr class="line-b">
              <p>Hover over the desired <?php echo $page; ?> and use the "Play" or "Stop" icons to create or delete a <?php echo $page; ?>. NOTE: In order for Multi DataCenter <?php echo $page; ?>s to function, all BIG-IP's in the <?php echo $page; ?> environment must be started. 
            </div>
          </div>
        </div>
<?php
  $fileloc=$webloc.$portal['branch']."/labs/";
  $data=getClassData($page, $fileloc);
  echo "<div class='zerogrid-b'>";
  foreach ($data as $k => $v) {
    echo "<div class='row'><div class='col-full' style='background: #3c5b74; color: #ffffff; padding: 6px 0px 6px 8px; margin-bottom:8px; font-size: 1.3em; '>".$k." Series: ".$data[$k]['title']."</div></div>";
    foreach ($data[$k] as $ck => $cv) {
      if ( is_numeric(substr($ck,0,3)) ) {
        echo "<div class='row' style='display: flex;'>";
        echo "<div style='width:10%; display: flex; flex: 1 0 auto; align-items: center; align-content: center; justify-content: center;float:left; text-align:center; background: #8a9cab; color:#ffffff; font-size:1.4em;'>".$ck."<br>".$data[$k][$ck]['title']."</div><div  style='width: 90%; float:left;'>"; 
        foreach ($data[$k][$ck]['labs'] as $lk => $lv) {
          launchclasstile($portal['branch'],$data[$k]['designation'],$data[$k][$ck]['designation'],$lk,urlencode($data[$k][$ck]['labs'][$lk]['title']),$data[$k][$ck]['labs'][$lk]['postman']);
        }
        echo "</div></div>";
        echo "<div class='row'><hr></div>";
      }
    }
  }
  echo "</div>";
?>
      </div>
    </div>
  </section>
<!-----------------end-content-box------------------->
