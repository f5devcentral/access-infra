<?php
  $host=explode(".", $_SERVER['HTTP_HOST']);
  $portal=strtoupper($host[0]);
?>
<!--#### FOOTER ##### -->
  <footer>
    <div class="copyright">
      <div class="zerogrid wrapper">
        <div style="float:left; width:33%; text-align:center;">@access:<?php echo $page."s"; ?> - <a href="https://github.com/f5devcentral/access-<?php echo $page."s"; ?>" target="_blank" rel="nofollow">Access: <?php echo $portal; ?></a></div>
        <div style="float:left; width:34%; text-align:center;">Portal Version: <?php echo $version; ?></div>
        <div style="float:left; width:33%; text-align:center;">Disclaimer: This is not an official web site for F5 Networks.</div>
      </div>
    </div>
  </footer>