#This is a shell Script tested on Ubuntu 12.04 LTS
#Pre Requirements
#Ubuntu 12.04 LTS Operating System

#find which OS install 
OS="`lsb_release -i | cut -d':' -f2 | awk '{print $1}'`"

if [ $OS != "Ubuntu" ];then
echo "This scripts is created to Work on Ubuntu" 1>&2
echo "Quiting..." 1>&2
exit 1

#Update a System
sudo apt-get update
sudo apt-get upgrade

#Check Which Software Installed Or not 
#checking for Nginx and PHP and MYSql. If not Installed than Install
PHP="php5-fpm"
WS="nginx"
DB="mysql-server"

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
echo " 127.0.0.1     $DOMAIN 
     " >> /ete/hosts

#Configuration File for hostname of Nginx web Server
#Nginx server host file placed at /etc/nginx/sites-available/default

#Create new Virtual Hostfile 
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$DOMAIN

#Set up virtual Host
echo "



