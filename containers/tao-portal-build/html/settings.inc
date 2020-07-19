<!--#### CONTENT ##### -->
  <!-----------------start-content-box-------------------->
    <section class="content-box boxstyle-2 box-3">
      <div class="zerogrid">
        <div class="row wrap-box">
          <div class="header2">
            <div class="wrapper">
              <div class="intro">Updating Portal/DevPortal Container</div>
              <hr class="line-b">
              <div class="lead">Using the "Redeploy Portal" button below will redeploy the Portal/Devportal container updating it to the latest code version.</div>
                <table id='repo' width='100%'><tr><th>Current Portal/Devportal Version</th><th>Updated Version</th><th>Action</th></tr>
                  <tr><td><?php echo "v".$version; ?></td><td>None Available</td><td><input id='repobutton' type='submit' name='submit' value='Redeploy'></tr>
                </table>
            </div>
          </div>
          <div class="header2">
            <div class="wrapper">
              <div class="intro">Control Git Auto-Updating (Pull) Functionality</div>
              <hr class="line-b">
              <div class="lead">The following toggles (enable/disable) the Git scripted cron jobs used for auto-updating the Access Labs & Solutions Repositories (master & dev) within this deployment/blueprint.</div>
            </div>
          </div>
          <div class="row">
            <div class="wrapper">
              <div style="float:left; width:60%;">Auto-Update for Access-Labs:Master Repository: </div><div style="float:left; width:40%;"><label class="switch"><input name="1" class="switch-input" type="checkbox" checked/><span class="switch-label" data-on="Enabled" data-off="Disabled"></span><span class="switch-handle"></span><br></label></div>
              <div style="float:left; width:60%;">Auto-Update for Access-Labs:Dev Repository: </div><div style="float:left; width:40%;"><label class="switch"><input name="1" class="switch-input" type="checkbox" /><span class="switch-label" data-on="Enabled" data-off="Disabled"></span><span class="switch-handle"></span><br></label></div>
              <div style="float:left; width:60%;">Auto-Update for Access-Solutions:Master Repository: </div><div style="float:left; width:40%;"><label class="switch"><input name="1" class="switch-input" type="checkbox" checked/><span class="switch-label" data-on="Enabled" data-off="Disabled"></span><span class="switch-handle"></span><br></label></div>
              <div style="float:left; width:60%;">Auto-Update for Access-Solutions:Dev Repository: </div><div style="float:left; width:40%;"><label class="switch"><input name="1" class="switch-input" type="checkbox" /><span class="switch-label" data-on="Enabled" data-off="Disabled"></span><span class="switch-handle"></span><br></label></div>
            </div>
          </div>
          <div class="header2">
            <div class="wrapper">
              <div class="lead">The following toggles (enable/disable) the cron jobs used for auto-updating custom repositories within this deployment/blueprint.</div>
            </div>
          </div>
          <div class="row">
            <div class="wrapper">
              <div style="float:left; width:60%;">Auto-Update for Access-Infra:Custom Repositories: </div><div style="float:left; width:40%;"><label class="switch"><input name="1" class="switch-input" type="checkbox" /><span class="switch-label" data-on="Enabled" data-off="Disabled"></span><span class="switch-handle"></span><br></label></div>
            </div>
          </div>
        </div>
      </div>
    </section>
  <!-----------------end-content-box--------------------->
