<!--#### HEADER ##### -->
  <header>
  <div style="display:table;width:100%;">
    <div id="cssmenu" >
      <ul>
        <li class="active"><a href='./index.php?page=solution'><span>Access: <?php echo strtoupper($portal['host']); ?></span></a></li>
        <?php
          switch ($portal['host']) {
            case "portal":
              echo "<li><a href='./index.php?page=lab'><span>Labs</span></a></li>";
              echo "<li class='last'><a href='./index.php?page=solution'><span>Solutions</span></a></li>";
			  echo "<li><a href='./index.php?page=class'><span>Classes</span></a></li>";
              break;
            case "devportal":
              echo "<li><a href='./index.php?page=lab'><span>Labs</span></a></li>";
              echo "<li><a href='./index.php?page=solution'><span>Solutions</span></a></li>";
              echo "<li><a href='./index.php?page=class'><span>Classes</span></a></li>";
              echo "<li class='last'><a href='./index.php?page=repo'><span>DEV Repos</span></a></li>";
              break;
            default:
              break;
            }       
        ?>        
      </ul>
    </div>
    <div id="filtermenu" >
      <form action='/index.php'>
        <input id='filterinput' type='text' name='filter'>
        <input type='hidden' name='page' value='<?php echo $page; ?>'></i>
      </form>
    </div>
    <div id="settingsmenu">      
      <a href='./index.php?page=settings'><img style="vertical-align:middle" src="./img/settings.png" width="22px"></a>
    </div>																												   
  </div>
  </header>
