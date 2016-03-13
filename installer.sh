#!/bin/bash
echo "Copyright (C) 2016 Geoffrey 'bn_'"
echo 
echo "This program is free software: you can redistribute it and/or modify"
echo "it under the terms of the GNU General Public License as published by"
echo "the Free Software Foundation, either version 3 of the License, or"
echo "any later version."
echo 
echo "This program is distributed in the hope that it will be useful,"
echo "but WITHOUT ANY WARRANTY; without even the implied warranty of"
echo "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
echo "GNU General Public License for more details."
echo 
echo "You should have received a copy of the GNU General Public License"
echo "along with this program.  If not, see <http://www.gnu.org/licenses/>."
echo

## Other variables
lc_base_folder=/usr/local/lancache
lc_nginx_loc=/usr/local/nginx
lc_srv_loc=/srv/lancache
lc_bind_loc=/etc/bind
lc_date=$( date +"%m-%d-%y %T" )
lc_hn=$( hostname )
lc_int_log=interface_used.log
lc_list_int=$( ls /sys/class/net )
lc_ip_googledns1=8.8.8.8
lc_ip_googledns2=8.8.4.4
lc_ip_logfile=ip.log
lc_ip_gw=$( /sbin/ip route | awk '/default/ { print $3 }' )

## Check if the necessary folders exist for this to work
if [ ! -d "$lc_base_folder/config" ]; then
	sudo mkdir -p $lc_base_folder/config/
fi

if [ ! -d "$lc_base_folder/data" ]; then
	sudo mkdir -p $lc_base_folder/data/
fi

if [ ! -d "$lc_base_folder/logs" ]; then
	sudo mkdir -p $lc_base_folder/logs
fi

sudo chown -R $USER:$USER $lc_base_folder

## Save the MacAdresses if not already done
lc_list_int=$( ls /sys/class/net | grep -v lo)
lc_list_mac=$( cat /sys/class/net/*/address | grep -v 00:00:00:00:00:00 )
echo The MAC Adresses for these Interfaces are:
echo $lc_list_int
echo $lc_list_mac

echo The MAC Adresses for these Interfaces are:>$lc_base_folder/config/interface_macadresses
echo $lc_list_int >>$lc_base_folder/config/interface_macadresses
echo $lc_list_mac >>$lc_base_folder/config/interface_macadresses

## Check if the Interface is defined
## If not will ask for the question
if [ ! -f "$lc_base_folder/config/interface_used" ]; then
	if [ "$lc_base_folder/config/interface_used" ]; then
		rm -rf $lc_base_folder/config/interface_used
	fi

	echo Please Enter The Interface to Use:
	echo The Interfaces on this machine are: $lc_list_int
		read lc_input
	echo You have Entered: $lc_input
	lc_input_interface=$lc_input
	echo
	echo Checking if this Interface Exists...

	## Built in Check
	ls /sys/class/net | grep $lc_input_interface >/dev/null
	if [ $? != 0 ]; then
		echo [ lc_date ] !!! ERROR !!! >>$lc_base_folder/logs/$lc_ip_logfile
		echo Sorry you have entered a wrong interface...
		echo 
		echo The user $USER entered the following interface: $lc_input_interface >>$lc_base_folder/logs/$lc_int_log
		echo Wich doesnt exist >>$lc_base_folder/logs/$lc_int_log
		echo
		echo The Available Interfaces $USER could choose from: $lc_list_int >>$lc_base_folder/logs/$lc_int_log
	else
		echo It seems that $lc_input_interface exists
		echo
		echo Now Defining the necessary files
		echo $lc_input_interface >$lc_base_folder/config/interface_used
		echo >>$lc_base_folder/logs/$lc_int_log
		echo [ lc_date ] !!! SUCCES !!! >>$lc_base_folder/logs/$lc_int_log
		echo The user $USER choose the following interface: $lc_input_interface from $lc_list_int >>$lc_base_folder/logs/$lc_int_log
	fi
fi
## Divide the ip in variables
lc_eth_int=$( cat $lc_base_folder/config/interface_used )
lc_ip=$(echo `ifconfig $lc_eth_int 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'` )
lc_eth_netmask=$( ifconfig $lc_eth_int |sed -rn '2s/ .*:(.*)$/\1/p' )
lc_ip_p1=$(echo ${lc_ip} | tr "." " " | awk '{ print $1 }')
lc_ip_p2=$(echo ${lc_ip} | tr "." " " | awk '{ print $2 }')
lc_ip_p3=$(echo ${lc_ip} | tr "." " " | awk '{ print $3 }')
lc_ip_p4=$(echo ${lc_ip} | tr "." " " | awk '{ print $4 }')

## Increment the last IP digit for every Game
lc_incr_arena=$((lc_ip_p4+1))
lc_ip_arena=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_arena
lc_incr_blizzard=$((lc_ip_p4+2))
lc_ip_blizzard=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_blizzard
lc_incr_gog=$((lc_ip_p4+3))
lc_ip_gog=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_gog
lc_incr_hirez=$((lc_ip_p4+4))
lc_ip_hirez=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_hirez
lc_incr_microsoft=$((lc_ip_p4+5))
lc_ip_microsoft=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_microsoft
lc_incr_origin=$((lc_ip_p4+6))
lc_ip_origin=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_origin
lc_incr_riot=$((lc_ip_p4+7))
lc_ip_riot=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_riot
lc_incr_steam=$((lc_ip_p4+8))
lc_ip_steam=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_steam
lc_incr_sony=$((lc_ip_p4+9))
lc_ip_sony=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_sony
lc_incr_tera=$((lc_ip_p4+10))
lc_ip_tera=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_tera
lc_incr_wargaming=$((lc_ip_p4+11))
lc_ip_wargaming=$lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_incr_wargaming

## Put IP's in the log file
echo [ lc_date ] Information !!! >>$lc_base_folder/logs/$lc_ip_logfile
echo IP Addresses beeing used: >>$lc_base_folder/logs/$lc_ip_logfile
echo >>$lc_base_folder/logs/$lc_ip_logfile
echo IP for $lc_eth_int is $lc_ip_p1.$lc_ip_p2.$lc_ip_p3.$lc_ip_p4 >>$lc_base_folder/logs/$lc_ip_logfile
echo Netmask for $lc_eth_int is lc_eth_netmask >>$lc_base_folder/logs/$lc_ip_logfile
echo >>$lc_base_folder/logs/$lc_ip_logfile
echo Arena: $lc_ip_arena >>$lc_base_folder/logs/$lc_ip_logfile
echo Blizzard: $lc_ip_blizzard >>$lc_base_folder/logs/$lc_ip_logfile
echo GOG: $lc_ip_gog >>$lc_base_folder/logs/$lc_ip_logfile
echo Hirez: $lc_ip_hirez >>$lc_base_folder/logs/$lc_ip_logfile
echo Microsoft: $lc_ip_microsoft >>$lc_base_folder/logs/$lc_ip_logfile
echo Origin: $lc_ip_origin >>$lc_base_folder/logs/$lc_ip_logfile
echo Riot: $lc_ip_riot >>$lc_base_folder/logs/$lc_ip_logfile
echo Steam: $lc_ip_steam >>$lc_base_folder/logs/$lc_ip_logfile
echo Sony: $lc_ip_sony >>$lc_base_folder/logs/$lc_ip_logfile
echo Tera: $lc_ip_tera >>$lc_base_folder/logs/$lc_ip_logfile
echo Wargaming: $lc_ip_wargaming >>$lc_base_folder/logs/$lc_ip_logfile

## Check if the Temp Folder Exists
## Normally this should not exist
if [ ! -d "$lc_base_folder/temp" ]; then
mkdir $lc_base_folder/temp
fi




## Check if the Lancache user exists if not creating the user
if id -u "lancache" >/dev/null 2>&1; then
	echo The user lancache exists so nothing needs to be done!
else
    sudo adduser --system --no-create-home lancache
    sudo addgroup --system lancache
    sudo usermod -aG lancache lancache
fi

## Creating the Necessary Folders for Lancache Data
if [ ! -d "$lc_srv_loc" ]; then
sudo mkdir -p $lc_srv_loc/data/blizzard
sudo mkdir -p $lc_srv_loc/data/microsoft
sudo mkdir -p $lc_srv_loc/data/installs
sudo mkdir -p $lc_srv_loc/data/other
sudo mkdir -p $lc_srv_loc/data/tmp
sudo mkdir -p $lc_srv_loc/data/hirez/
sudo mkdir -p $lc_srv_loc/data/origin/
sudo mkdir -p $lc_srv_loc/data/riot/
sudo mkdir -p $lc_srv_loc/data/sony/
sudo mkdir -p $lc_srv_loc/data/steam/
sudo mkdir -p $lc_srv_loc/logs
sudo mkdir -p $lc_srv_loc/data/wargaming
sudo mkdir -p $lc_srv_loc/data/tera
sudo mkdir -p $lc_srv_loc/data/arenanetworks
sudo chown -R lancache:lancache $lc_srv_loc/
sudo chmod 755 -R $lc_srv_loc/
fi

## Checking if GIT is installed if not installing it
if [ ! -f "/user/bin/git" ]; then
	sudo apt-get install git -y >/dev/null
fi

## Check if BIND9 is installed and if its not installing it
if [ ! -d "$lc_bind_loc" ]; then
	sudo apt-get install bind9 -y>/dev/null
fi

## Checking Build Essential is installed if not installing it
if [ ! -f "/user/bin/make" ]; then
	sudo apt-get install build-essential -y>/dev/null
fi

## Download Lancache into Data Folder if not yet done
if [ ! -d "$lc_base_folder/data/lancache" ]; then
	cd $lc_base_folder/data/
	git clone -b installer http://github.com/bntjah/lancache>/dev/null
fi

## Download and extract Nginx if not yet done
if [ ! -d "$lc_base_folder/data/nginx-1.9.9" ]; then
	cd $lc_base_folder/data
	curl http://nginx.org/download/nginx-1.9.9.tar.gz | tar zx>/dev/null
fi

## Check if NGINX is installed and if its not installing it
if [ ! -d "$lc_nginx_loc" ]; then
	cd $lc_base_folder/data/nginx-1.9.9
	sudo apt-get install libpcre3 libpcre3-dev zlib1g-dev libreadline-dev libncurses5-dev libssl-dev -y
	./configure --with-http_ssl_module --with-http_slice_module
	sudo make
	sudo make install
fi

## Doing the necessary changes for Lancache
if [ ! -d "$lc_nginx_loc/conf/lancache" ]; then
	cd $lc_base_folder/data/lancache/conf
	sudo mv $lc_nginx_loc/conf/nginx.conf $lc_nginx_loc/conf/nginx.conf.bak
	sudo cp $lc_base_folder/data/lancache/conf/nginx.conf $lc_nginx_loc/conf/nginx.conf
	sudo mkdir $lc_nginx_loc/conf/lancache
	sudo mkdir $lc_nginx_loc/conf/vhosts_enabled/
	sudo cp $lc_base_folder/data/lancache/conf/lancache/* $lc_nginx_loc/conf/lancache
	sudo cp $lc_base_folder/data/lancache/conf/vhosts-enabled/*.conf $lc_nginx_loc/conf/vhosts_enabled/
fi

## Checking if the Limits of the system are changed
## for Lancache to work without issues
if [ -f "/etc/security/limits.conf" ]; then
	cat /etc/security/limits.conf | grep 65536>/dev/null
	if [ $? != 0 ]; then
		sudo mv /etc/security/limits.conf /etc/security/limits.conf.bak
		sudo cp $lc_base_folder/data/lancache/limits.conf /etc/security/limits.conf
	fi
fi

## Preparing Bind For The Changes to Come
if [ -f "/etc/bind/named.conf" ]; then
	cat /etc/bind/named.conf | grep lan-cache>/dev/null
	if [ $? != 0 ]; then
		sudo service bind9 stop
		sudo mv /etc/bind/named.conf /etc/bind/named.conf.bak
		if [ ! -d "$lc_base_folder/temp/bind" ]; then
		sudo mkdir -p $lc_base_folder/temp/bind
		sudo cp $lc_base_folder/data/lancache/bind/db.lancache.* $lc_base_folder/temp/bind
		sudo cp $lc_base_folder/data/lancache/bind/named.conf.* $lc_bind_loc/
	fi
fi

if [ ! -f "/etc/bind/named.conf.local.lan-cache" ]; then
	sed -i 's|lc-hostname|'$lc_hn'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-proxybind|'$lc_ip'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-gw|'$lc_ip_gw'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-arena|'$lc_ip_arena'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-blizzard|'$lc_ip_blizzard'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-hirez|'$lc_ip_hirez'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-gog|'$lc_ip_gog'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-microsoft|'$lc_ip_microsoft'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-origin|'$lc_ip_origin'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-riot|'$lc_ip_riot'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-steam|'$lc_ip_steam'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-sony|'$lc_ip_sony'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-tera|'$lc_ip_tera'|g' $lc_base_folder/temp/bind/db.lancache.*
	sed -i 's|lc-host-wargaming|'$lc_ip_wargaming'|g' $lc_base_folder/temp/bind/db.lancache.*
	sudo cp $lc_base_folder/temp/bind/db.lancache.* $lc_bind_loc/
	sudo service bind9 start
fi

## Copy The Base Files Over To Temp Folder
cp $lc_base_folder/data/lancache/hosts $lc_base_folder/temp/hosts
cp $lc_base_folder/data/lancache/interfaces $lc_base_folder/temp/interfaces

## Make the Necessary Changes For The New Host File
sed -i 's|lc-hostname|'$lc_hn'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-proxybind|'$lc_ip'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-arena|'$lc_ip_arena'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-blizzard|'$lc_ip_blizzard'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-hirez|'$lc_ip_hirez'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-gog|'$lc_ip_gog'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-microsoft|'$lc_ip_microsoft'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-origin|'$lc_ip_origin'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-riot|'$lc_ip_riot'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-steam|'$lc_ip_steam'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-sony|'$lc_ip_sony'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-tera|'$lc_ip_tera'|g' $lc_base_folder/temp/hosts
sed -i 's|lc-host-wargaming|'$lc_ip_wargaming'|g' $lc_base_folder/temp/hosts

## Make the Necessary Changes For The New Interfaces File
sed -i 's|lc-host-arena|'$lc_ip_arena'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-blizzard|'$lc_ip_blizzard'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-hirez|'$lc_ip_hirez'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-gog|'$lc_ip_gog'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-microsoft|'$lc_ip_microsoft'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-origin|'$lc_ip_origin'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-riot|'$lc_ip_riot'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-steam|'$lc_ip_steam'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-sony|'$lc_ip_sony'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-tera|'$lc_ip_tera'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-wargaming|'$lc_ip_wargaming'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-netmask|'$lc_eth_netmask'|g' $lc_base_folder/temp/interfaces
sed -i 's|lc-host-vint|'$lc_eth_int'|g' $lc_base_folder/temp/interfaces

## Change the Proxy Bind in Lancache Configs
sudo sed -i 's|lc-host-proxybind|'$lc_ip'|g' $lc_nginx_loc/conf/vhosts_enabled/*.conf

## Copy The init.d file over to /etc/init.d/
if [ ! -f "/etc/init.d/lancache" ]; then
	sudo cp $lc_base_folder/data/lancache/init.d/lancache /etc/init.d/lancache
	sudo chmod +x /etc/init.d/lancache
fi

## Moving Base Files to The Correct Locations if not already installed
if [ -f "/etc/hosts" ]; then
	cat /etc/hosts | grep lancache-*>/dev/null
	if [ $? != 0 ]; then
		sudo mv /etc/hosts /etc/hosts.bak
		sudo mv $lc_base_folder/temp/hosts /etc/hosts
	fi
fi

if [ -f "/etc/network/interfaces" ]; then
	cat /etc/network/interfaces | grep $lc_ip_steam>/dev/null
	if [ $? != 0 ]; then
		sudo mv /etc/network/interfaces /etc/network/interfaces.bak
		sudo mv $lc_base_folder/temp/interfaces /etc/network/interfaces
	fi
fi

if [ -f "/etc/dhcp/dhclient.conf" ]; then
	cat /etc/dhcp/dhclient.conf | grep $lc_ip_googledns1>/dev/null
	if [ $? != 0 ]; then
		sudo mv /etc/dhcp/dhclient.conf /etc/dhcp/dhclient.conf.bak
		sudo cp $lc_base_folder/data/lancache/dhclient.conf /etc/dhcp/dhclient.conf
	fi
fi

## Clean up temp folder
sudo rm -rf $lc_base_folder/temp
fi

exit 0