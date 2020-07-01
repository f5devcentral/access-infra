#!/bin/sh
cd /www/sites/files-dev.f5lab.local/solutions
git pull -q origin dev 
cd /www/sites/files-dev.f5lab.local/labs
git pull -q origin dev 