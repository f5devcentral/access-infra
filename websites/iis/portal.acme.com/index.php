<?php
// Function Includes  
  include './mainFunc.inc';
// File Includes
  include './inc/error.inc';
  portalHeader();
?>

<body>
  <?php pageHeader(); ?>
  <div id="contentWrapper">
    <form id="portalloginForm" class="form" action="./login.php" method="post" autocomplete="off">
      <div id="logonBox">
        <div id="login" class="logonBoxCentered">
          <div id="usernameContainer">
            <div class="label-container"><label for="username">Username</label></div>
            <input class="inputText" type="text" name="uid" id="uid" tabindex="1" autocomplete="off" />
          </div>
          <div id="passwordContainer">
            <div class="label-container"><label for="password">Password</label></div>
            <input class="inputText" type="password" name="pwd" id="pwd"  tabindex="2" autocomplete="off" />
          </div>
        </div>
      </div>
      <?php
        if (isset($_GET['id']) && $_GET['id']>=1) { echo "<div id='content-err'>".${m.$_GET['id']}."</div>"; }
      ?>      
      <div id="content2">
        <div class="centeredContent">
          <div id="submitButton" class="formActions">
            <input class="button" type="submit" id="submit" tabindex="3" value="Log In" />
          </div>
        </div>
      </div>
    </form>
  </div>
</body>
<?php
  portalEnd();
?>
