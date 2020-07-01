#!/bin/sh

/start_crond.sh -D

/start_php-fpm.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "php-fpm Failed: $status"
  exit $status
  else echo "Starting PHP-FPM: OK"
fi

sleep 2

/start_nginx.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Nginx Failed: $status"
  exit $status
  else echo "Starting Nginx: OK"
fi

sleep 2

while /bin/true; do
  ps aux | grep 'php-fpm: master process' | grep -q -v grep
  PHP_FPM_STATUS=$?
  echo "Checking PHP-FPM, Status Code: $PHP_FPM_STATUS"
  sleep 2

  ps aux | grep 'nginx: master process' | grep -q -v grep
  NGINX_STATUS=$?
  echo "Checking NGINX, Status Code: $NGINX_STATUS"
  sleep 2

  if [ $PHP_FPM_STATUS -ne 0 ];
    then
      echo "$(date +%F_%T) FATAL: PHP-FPM Raised a Status Code of $PHP_FPM_STATUS and exited"
      exit -1

   elif [ $NGINX_STATUS -ne 0 ];
     then
       echo "$(date +%F_%T) FATAL: NGINX Raised a Status Code of $NGINX_STATUS and exited"
       exit -1

   else
     sleep 2
        echo "$(date +%F_%T) - HealthCheck: NGINX and PHP-FPM: OK"
  fi
  sleep 60
done
