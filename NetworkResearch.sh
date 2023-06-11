#!/bin/bash

#Name:Segev Danoch
#ID:206432767
#Class code:7736/13
#Lecturer's Name: Adonis Azzam



if [ $(id -u) -ne 0 ]
then

echo "This script must be ran as root"
exit 
fi


#checking if the following applications are installed:Anonsurf,Sshpass,Geoiplookup
function anoninstall () {
echo "checking if the following application is installed:Sshpass"
sleep 2
install=$(dpkg -s sshpass 2>/dev/null)
if [[ -z $install ]]
then
echo "Sshpass is not installed,installing"
apt-get install sshpass -y
else
sleep 2
echo "sshpass is already installed"
fi
sleep 2
echo "checking if the following application is installed:Anonsurf"
anocheck=$(dpkg -s kali-anonsurf 2>/dev/null)
sleep 2
if [[ -z $anocheck ]]
then
sleep 2
echo "anonsurf is not installed, installing"
    git clone https://github.com/Und3rf10w/kali-anonsurf.git && cd kali-anonsurf && bash installer.sh 
else
sleep 2
echo "Anonsurf is already installed " 
fi
echo "checking if the following application is installed:Geoiplookip"
sleep 2
install=$(dpkg -s geoip-bin 2>/dev/null)
if [[ -z $install ]]
then
sleep 2
echo "Geoiplookup is not installed,installing"
apt-get install geoip-bin -y
else
sleep 2
echo "Geoiplookup is already installed"
fi
install=$(dpkg -s tor 2>/dev/null)
if [[ -z $install ]]
then
sleep 2
echo "Tor is not installed,installing"
apt-get install -y tor 
else
sleep 2
echo "Tor is already installed"
fi
}
anoninstall

#checking if the User is anonymous:



function anoncheck () {
echo "checking if user is anonymous"
destatus=$(anonsurf status | head -3 | tail -1 | awk '{print $2}')
if [ $destatus == "active" ]
then
echo " user is anonymous"
else
echo "user is not anonymous,starting anonsurf"
anonsurf start
fi
loc=$(geoiplookup  $(curl -s ifconfig.me) | awk '{print $4}' | sed 's/,//g')
if [[ $loc != IL ]]
then 
echo "ensuring if the user is anonymous"
echo "user is anonymous"
echo "$loc"
else
echo "user is not anonymous"
exit
fi
}
anoncheck

#allows the user to type a domain/ip address

function  ip_hacker () { 
echo "type domain/ip address "
read x
}
ip_hacker
x='8.8.8.8'
#displaying the details of the remote server and saves the data into a file.
function  safe () {
echo "user's current location is:"
sshpass -p kali ssh -o StrictHostKeyChecking=no kali@192.168.181.128 "geoiplookup $(curl -s ifconfig.me)"
echo "user's ip is:"
sshpass -p kali ssh -o StrictHostKeyChecking=no kali@192.168.181.128 "hostname -I"
echo "user has been up for:"
sshpass -p kali ssh -o StrictHostKeyChecking=no kali@192.168.181.128 "uptime"
echo "whois reply:" >> who.txt
sshpass -p kali ssh -o StrictHostKeyChecking=no kali@192.168.181.128 "whois $x" >> who.txt
echo "$(date) whoisdata for $x " >> NR.log
echo "nmap reply:" >> nmap.txt
sshpass -p kali ssh -o StrictHostKeyChecking=no kali@192.168.181.128 "nmap $x" >>  nmap.txt
echo "$(date) nmapdata for $x" >> NR.log
}
safe
