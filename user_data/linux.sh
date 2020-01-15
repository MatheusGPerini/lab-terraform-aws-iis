#!/bin/bash
sudo yum update httpd
sudo yum install httpd -y
sudo yum install git -y
mkdir /opt/project
cd /opt/project
git clone https://github.com/MatheusGPerini/lab-terraform-aws-iis.git
cp lab-terraform-aws-iis/site/index.html /var/www/html/
sudo systemctl start httpd