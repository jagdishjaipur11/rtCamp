#!/bin/bash
#This is a shell Script tested on Ubuntu 12.04 LTS
#Pre Requirements
#Ubuntu 12.04 LTS Operating System

#find which OS install 
OS="`lsb_release -i | cut -d':' -f2 | awk '{print $1}'`"

if [ $OS != "Ubuntu" ];then
echo "This scripts is works on only ubuntu OS" 1>&2
echo "Exit ....." 1>&2
exit 1

#Update a System
sudo apt-get update
sudo apt-get upgrade

#Check Which Software Installed Or not 
#checking for Nginx and PHP and MYSql. If not Installed than Install
PHP="php5-fpm"
WS="nginx"
DB="mysql-server"
TAR="tar"
DBUSER="root"
DBPASS="rtCamp@LinuxWorld!"

# For MySql DATABASE
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password rtCamp@LinuxWorld!'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password rtCamp@LinuxWorld!'

#Checking start for Packages
for pkg in $PHP $WS $DB; 
do
  if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
    echo -e "$pkg is already installed"
  elif apt-get -qq install $pkg; then
    echo "Successfully installed $pkg"
  else
    echo "Error installing $pkg"
  fi
done

#User Input for Domain Name
echo "Enter your domain (Like : example.com) : \n"
read DOMAIN

#Enter Details for hostname in /etc/hosts
echo "127.0.0.1     $DOMAIN 
     " >> /etc/hosts

#Make working directory
DIR="rtCamp"
sudo mkdir -p /var/www/$DIR
#Grant Permission
sudo chmod -R 755 /var/www
#Change ownership
sudo chown -R  www-data:www-data /var/www/$DIR

#Configuration File for hostname of Nginx web Server
#Nginx server host file placed at /etc/nginx/sites-available/default

#Create new Virtual Hostfile 
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$DOMAIN

#Set up virtual Host
echo "server {
	listen   80; ## listen for ipv4; this line is default and implied
	#listen   [::]:80 default ipv6only=on; ## listen for ipv6

	root /var/www/$DIR;
	index index.html index.htm;

	# Make site accessible from http://localhost/
	server_name $DOMAIN;
	
	error_page 404 /404.html;
	
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root /usr/share/nginx/www;
	}

	location ~ \.php$ {
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}

} " >> /etc/nginx/sites-available/$DOMAIN

#Enable example.com site
sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/$DOMAIN

#Download latest Wordpress 
cd /var/www/$DIR
sudo wget  http://wordpress.org/latest.tar.gz
#unzip downloaded tar file
sudo tar -xvzf latest.zip

#Create/Edit Wordpress configuration files
cd wordpress
sudo cp -rf wp-config-sample.php wp-config.php

#Create database password for Wordpress
echo "Enter Wordpress User Password \n"
read PASS

#Edit wp-config.php
sed "s/username_here/rtCampWP/" /var/www/$DOMAIN/wp-config.php
sed "s/database_name_here/$DOMAIN_db/" /var/www/$DOMAIN/wp-config.php 
sed "s/password_here/$PASS/" /var/www/$DOMAIN/wp-config.php

#Create database for Wordpress
PASS="Welcome@RtCamp#2014
sudo mysql -u=$DBUSER -p=$DBPASS -e "create database $DOMAIN_db; GRANT ALL PRIVILEGES ON $DOMAIN_db.* TO rtCampWP@localhost IDENTIFIED BY '$PASS';"





