<?php
  $host=explode(".", $_SERVER['HTTP_HOST']);
  $portal=strtoupper($host[0]);
?>
<!--#### FOOTER ##### -->
  <footer>
    <div class="copyright">
      <div class="zerogrid wrapper">
        @teamaccess - <a href="https://teamaccessonline.github.com" target="_blank" rel="nofollow">TeamAccess: <?php echo $portal; ?></a>
        <ul class="quick-link">
          <li>Disclaimer: This is not an official web site for F5 Networks.</li> 
        </ul>
      </div>
    </div>
  </footer>