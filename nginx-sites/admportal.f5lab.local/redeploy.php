<?php
  if (isset($_GET['repo'])) { 
    // echo "Starting to redeploy...<br>";
    $repo = strtolower($_GET['repo']);
    shell_exec('sudo docker stop tao-portal');
    shell_exec('sudo docker rm tao-portal');
    $cmd = "sudo docker build -t tao/tao-portal /var/files/infra-".$repo."/containers/tao-portal-build/";
    shell_exec($cmd);
    shell_exec('sudo docker run -d -p 8000:80 --hostname=tao-portal --restart=always --name tao-portal tao/tao-portal');
    // echo "Finishing redeployment...";
    $redirect = "Location: https://devportal.f5lab.local/index.php?page=settings";
    sleep(5);
    header($redirect); 
  } else {
    echo "Failed to deploy.";
  } 
?>
