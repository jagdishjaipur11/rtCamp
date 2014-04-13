#This is a shell Script tested on Ubuntu 12.04 LTS
#Pre Requirements
#Ubuntu 12.04 LTS Operating System

#Update a System
sudo apt-get update

#Check Which Software Installed Or not 
#checking for Nginx and PHP and MYSql. If not Installed than Install
PHP="php5"
WS="nginx"
DB="mysql"

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

#User Input for Hostname 
echo "Enter your hostname (Like : example.com) : \n"
read hostname

#Enter Details for hostname in /etc/hosts
echo " 127.0.0.1     $hostname 
     " > /ete/hosts

#Configuration File for hostname of Nginx web Server
