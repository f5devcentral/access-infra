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
        <div class='zerogrid' width='80%' style='background:#000000; color:#00FF00;'>
<?php
// $output = shell_exec('newman run /var/files/solution1/postman/solution1-create.postman_collection.json -e /var/files/solution1/postman/master-single-dc.postman_environment.json -k');
// echo "<pre>$output</pre>";
// $cmd='newman run /var/files/solution1/postman/solution1-create.postman_collection.json -e /var/files/solution1/postman/master-single-dc.postman_environment.json -k';
 $cmd='ls -latr';

while (@ ob_end_flush()); // end all output buffers if any
$proc = popen($cmd, 'r');
echo '<pre>';
while (!feof($proc))
{
    echo fread($proc, 4096);
    @ flush();
}
echo '</pre>';
?>
      </div>
      </div>
    </div>
  </section>
<!-----------------end-content-box------------------->
