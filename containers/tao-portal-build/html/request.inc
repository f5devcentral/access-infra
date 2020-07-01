<!--#### CONTENT: request ##### -->
  <?php
    include('./controlled-content.inc');
  ?>
  <!-----------------start-content-box-------------------->
    <section id="container">
      <div class="wrap-container">
        <div class="zerogrid">
          <div class="row">
            <div class="col-1-2">
              <div class="wrap-col">
                <h3 style="margin: 20px 0">Request Information</h3>
                <?php
                  echo "<center><img src='./img/".$controlled[$_GET['req']]['img']."' width='65%' style='box-shadow: 3px 3px 5px rgba(69, 69, 69, 0.75);'/></center>";
                  echo "<p><b>Description: </b><i>".$controlled[$_GET['req']]['descr']."</i></p>";
                ?>
              </div>
            </div>
            <div class="col-1-2">
              <div class="wrap-col">
                <h3 style="margin: 20px 0">&nbsp;</h3>
                <div class="contact">
                  <?php 
                    switch ($_GET['stat']) {
                      case "1":
                        echo "<p style='font-weight:normal'>You have requested the following presentation/document: <b>".$controlled[$_GET['req']]['title']."</b>.</p>";
                        echo "<p style='font-weight:normal'><b>STATUS: </b><font color='#009300'><b>EMAIL SENT</b></font>.</p>";
                        echo "<p style='font-weight:normal'>Please allow up to 24 hours for reciept of the requested presentation/document.<br><br>Thank You!</p>";
                        break;
                      case "2": 
                        echo "<div id='contact_form'><form name='form1' id='ff' method='post' action='./submitreq.php'><label class='row'><div class='col-full'>";
                        echo "<p style='font-weight:normal'><font color='#d50000'><b>ERROR: INVALID EMAIL ADDRESS</b></font>";
                        echo "<p style='font-weight:normal'>You have entered an invalid email address while requesting the following presentation/document: <b>".$controlled[$_GET['req']]['title']."</b>.</p>";
                        echo "<p style='font-weight:normal'>Please re-enter your email and your request will be forwardred to the content administrators who will reply sending the requested presentation/document to the email entered below.<br><br></p>";
                        echo "<input type='hidden' name='req' value='".$_GET['req']."'>";
                        echo "<div class='wrap-col'><input style='box-sizing: content-box;' size='10' type='text' name='email' id='subject' placeholder='Enter eMail' required='required' /></div>";
                        echo "</div></label><center><input class='sendButton' type='submit' name='submitcontact' value='Submit'></center></form></div>";
                        break;
                      default: 
                        echo "<div id='contact_form'><form name='form1' id='ff' method='post' action='./submitreq.php'><label class='row'><div class='col-full'>";
                        echo "<p style='font-weight:normal'>You are requesting the following presentation/document: <b>".$controlled[$_GET['req']]['title']."</b>.</p>";
                        echo "<p style='font-weight:normal'>Your request will be forwardred to the content administrators who will reply sending the requested presentation/document to the email entered below.<br><br></p>";
                        echo "<input type='hidden' name='req' value='".$_GET['req']."'>";
                        echo "<div class='wrap-col'><input style='box-sizing: content-box;' size='10' type='text' name='email' id='subject' placeholder='Enter eMail' required='required' /></div>";
                        echo "</div></label><center><input class='sendButton' type='submit' name='submitcontact' value='Submit'></center></form></div>";
                    }
                  ?>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  <!-----------------end-content-box-------------------->
