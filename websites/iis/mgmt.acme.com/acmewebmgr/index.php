<?php 
include './config.inc';
include './f5Func.inc';
?>

<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
<head>
  <title>ACME Server Manager</title>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
  <meta http-equiv='X-UA-Compatible' content='IE=edge' /> <!-- Make IE play nice -->
  <meta name='viewport' content='width=device-width, user-scalable=yes'/>
  <link rel='stylesheet' href='./main.css'>
</head>
<body>
  <div class='header'>
    <div class='header-content'>
      <div class='header-title'>ACME Server Manager - web.acme.com</div>
      <div class='header-subtitle'>System Tools</div>
    </div>
  </div>
  <div class='contentWrapper'>
    <div class='contentBox'>
      <div class='contentBoxCentered'>
        <?php
        // Query for Virtual Servers 
           $vs=json_decode(f5_Data("https://".$bigip."/mgmt/tm/ltm/virtual/?expandSubcollections=true"), true);
        // Virtual Server Listing
           echo "<center><table class='data'>";
           echo "<tr><td class='title' colspan='2'>VirtualServer</td>";
           echo "<td class='title' >Partition</td>";
           echo "<td class='title' >IP Address</td><td class='title'>Port&nbsp;</td><td class='title' colspan='2'>Pool</td><td class='title'>Members</td></tr>";
        // Virtual Server Information Loop
           for ($i=0; $i < count($vs['items']); $i++) {
             $vs_name=$vs['items'][$i]['name'];
             // *** FILTER START ***
             if ($vs_name=='acme_web.acme.com') {  
               $vs_partition=$vs["items"][$i]['partition'];
               if (empty($vs['items'][$i]['subPath'])) {
                 $vs_path=$vs['items'][$i]['partition'];
               } else {
                 $vs_path=$vs['items'][$i]['partition'].'~'.$vs['items'][$i]['subPath'];
               }
               $vs_destination=explode('/',$vs['items'][$i]['destination']);
               $vs_ip_info=explode(':',$vs_destination[2]);
               $vs_ip=$vs_ip_info[0];
               $vs_port=$vs_ip_info[1];
               $vs_pool=$vs['items'][$i]['pool'];
               // Virtual Server Status
               $vs_status=json_decode(f5_Data("https://".$bigip."/mgmt/tm/ltm/virtual/~".$vs_path."~".$vs_name."/stats"), true);
               $vs_selflink_full=explode("?",$vs_status['selfLink']);
               $vs_selflink=$vs_selflink_full[0];
               $vs_avail_state=$vs_status['entries'][$vs_selflink]['nestedStats']['entries']['status.availabilityState']['description'];
               $vs_enable_state=$vs_status['entries'][$vs_selflink]['nestedStats']['entries']['status.enabledState']['description'];
               $vs_status_reason=$vs_status['entries'][$vs_selflink]['nestedStats']['entries']['status.statusReason']['description']; 
               // Virtual Server Display
               $server_icon=f5_Status_Icon($vs_avail_state,$vs_enable_state);
               echo "<tr><td class='status'><a title=\"".$vs_status_reason."\" class='tooltip'><img src='./img/".$server_icon."_sm.png'></a></td>";
               echo "<td class='server'>".$vs_name."</td>";
               echo "<td class='value'>".$vs_partition."</td>";
               echo "<td class='value'>".$vs_ip."</td><td class='value'>".$vs_port."</td>";
               // Virtual Server Pool Information
               if (!empty($vs_pool)) { 
                 $vs_pool_info=explode("/",$vs_pool);
                 $vs_pool_partition=$vs_pool_info[1];
                 $vs_pool_name=$vs_pool_info[2];
                 // Virtual Server Pool Status  
                 $vs_pool_status=json_decode(f5_Data("https://".$bigip."/mgmt/tm/ltm/pool/~".$vs_pool_partition."~".$vs_pool_name."/stats"), true);
                 $vs_pool_selflink_full=explode("?",$vs_pool_status['selfLink']);
                 $vs_pool_selflink=$vs_pool_selflink_full[0];
                 $vs_pool_avail_state=$vs_pool_status['entries'][$vs_pool_selflink]['nestedStats']['entries']['status.availabilityState']['description'];
                 $vs_pool_enable_state=$vs_pool_status['entries'][$vs_pool_selflink]['nestedStats']['entries']['status.enabledState']['description'];
                 $vs_pool_status_reason=$vs_pool_status['entries'][$vs_pool_selflink]['nestedStats']['entries']['status.statusReason']['description']; 
                 // Virtual Server Pool Display
                 $pool_icon=f5_Status_Icon($vs_pool_avail_state,$vs_pool_enable_state);
                 echo "<td class='status'><a title=\"".$vs_status_reason."\" class='tooltip'><img src='./img/".$pool_icon."_sm.png'></a></td><td class='server'>".$vs_pool_name."</td>";
                 // VirtualServer Pool Details
                 $vs_pool_details=json_decode(f5_Data("https://".$bigip."/mgmt/tm/ltm/pool/~".$vs_pool_partition."~".$vs_pool_name."/?expandSubcollections=true"), true);
                 // Virtual Server Members  
                 echo "<td class='value'><table class='members'>";
                 for ($m=0; $m < count($vs_pool_details["membersReference"]["items"]); $m++) {
                   $vs_member=$vs_pool_details["membersReference"]["items"][$m]["name"];
                   $vs_member_ip=$vs_pool_details["membersReference"]["items"][$m]["address"];
                   $vs_member_session=$vs_pool_details["membersReference"]["items"][$m]["session"];
                   $vs_member_state=$vs_pool_details["membersReference"]["items"][$m]["state"];
                   $vs_member_fullpath=strtr($vs_pool_details['membersReference']['items'][$m]['fullPath'],'/', '~');
                   $member_icon=f5_Status_Icon($vs_member_state,$vs_member_session);
                   echo "<tr><td width='5%'><a title=\"".$vs_member_state.":".$vs_member_session."\" class='tooltip'><img src='./img/".$member_icon."_sm.png'></a></td><td width='55%'>".$vs_member."</td>";
                   echo "<td width='10%'><form style='margin:0; padding:0;' action='memberAction.php' method='POST'><input type='hidden' name='pool' value='~".$vs_pool_partition."~".$vs_pool_name."'/><input type='hidden' name='member' value='".$vs_member_fullpath."'/><input type='hidden' name='action' value='enable'/><input type='submit' value='enable'></form></td>";
                   echo "<td width='10%'><form style='margin:0; padding:0;' action='memberAction.php' method='POST'><input type='hidden' name='pool' value='~".$vs_pool_partition."~".$vs_pool_name."'/><input type='hidden' name='member' value='".$vs_member_fullpath."'/><input type='hidden' name='action' value='disable'/><input type='submit' value='disable'></form></td>";
                   echo "<td width='10%'><form style='margin:0; padding:0;' action='memberAction.php' method='POST'><input type='hidden' name='pool' value='~".$vs_pool_partition."~".$vs_pool_name."'/><input type='hidden' name='member' value='".$vs_member_fullpath."'/><input type='hidden' name='action' value='offline'/><input type='submit' value='offline'></form></td>";
                   echo "<td width='10%'><form style='margin:0; padding:0;' action='memberAction.php' method='POST'><input type='hidden' name='pool' value='~".$vs_pool_partition."~".$vs_pool_name."'/><input type='hidden' name='member' value='".$vs_member_fullpath."'/><input type='hidden' name='action' value='kill'/><input type='submit' value='kill'></form></td>";
                 }
               echo "</table></td>";
               } else {
                 echo "<td class='value' colspan='3'><center>No assigned pool/members</center></td>";
               }
               echo "</tr>";
             // *** FILTER START ***
             }
           }
           echo "</table></center>";
         ?>
       </div>
    </div>
  </div>
  <div class='footer'>
    <div class='footer-content'>
      <div class='footer-title'>&nbsp;</div>
    </div>
  </div>
</body>
</html>