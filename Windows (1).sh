#!/bin/bash



#Name:Segev Danoch
#Class code: 7736/13
#Lecturer's name: Adonis Azzam
#Credit:ChatGpt

#checking to see if the user run as root

if [ $(id -u) -ne 0 ]
then
echo "This script must be ran as root"
    exit 
fi

#allow the user to specify a file path and check if the file exists:

echo "Enter a file path" 

read path


if [ -f $path ]
then
echo "The file exists"
else
echo "the file does not exist" 
exit
fi

#checking to see if the following applications are installed:Bulk extractor,Binwalk,Foremost,Strings,Volatility 

function Cielo () {
echo "go grab some popcorn, this might take a while..."
sleep 3	
echo "checking if the following application is installed: bulk extractor"
sleep 2
Bulcky=$(dpkg -s bulk-extractor>/dev/null)
if [[ ! -z $Bulcky ]]
then
echo "Bulk extractor is not installed,installing"
apt-get install bulk-extractor -y
else 
echo "Bulk extractor is already installed"
fi
echo "checking if the following application is installed: Binwalk"
sleep 2
Bin=$(dpkg -s binwalk>/dev/null)
if [[ ! -z $Bin ]]
then 
echo "Binwalk is not installed,installing"
apt-get install binwalk -y
else
echo "Binwalk is already installed"
fi
sleep 2
echo "checking if the following application is installed:Foremost"
sleep 2
Forno=$(dpkg -s foremost>/dev/null)
if [[ ! -z $Forno ]]
then
echo "Foremost is not installed,installing"
apt-get install foremost -y
else
echo "Formeost is already installed"
fi
echo "checking if the following application is installed: Strings"
sleep 2
Strength=$(dpkg -s binutils>/dev/null)
if [[ ! -z $Strength ]]
then
echo "Strings is not installed,installing"
apt-get install binutils -y 
else
echo "Strings is already installed"
fi
echo "checking if the following application is installed: Volatility"
sleep 2
if  [[ ! -d volatility_2.6_lin64_standalone  ]] 
then
echo "Volatility is not installed, installing"
wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip > /dev/null
unzip volatility_2.6_lin64_standalone.zip
chmod 777 volatility_2.6_lin64_standalone
rm -rf volatility_2.6_lin64_standalone.zip
else
echo "Volatility is already installed"
fi
}
Cielo


#Allow the user to specify which he wants to carve:Memory File/Hard Disk Drive file

function mem () {
echo "Carving with Foremost..."
foremost -t all $path -o Data

echo "Carving with Bulky..." 

bulk_extractor $path -o Data >/dev/null

echo "Carving with Binwalk..."
binwalk $path >> Data/Carl.txt

echo "Carving with Strings..."
strings $path >> Data/Spider.txt
echo "All successful Carving attempts are stored in Data Directory"

}


function hdd () {
echo "Carving with Foremost..."
foremost -t all $path -o Datadisk

echo "Carving with Bulky..." 
bulk_extractor $path -o Datadisk >/dev/null

echo "Carving with Binwalk..."
binwalk $path >> Datadisk/Rick.txt

echo "Carving with Strings..."
strings $path >> Datadisk/Spider.txt
echo "All successful Carving attempts are stored in Datadisk Directory"
}

function r () {
echo "Choose a file type:
1.Memory file
2.Hard disk drive"

read ng


if [ $ng -eq 1 ]
then 
mem
elif [ $ng -eq 2 ]
then
hdd
else
echo "please choose 1 or 2 "
r
fi
}
r

#Extracting the user's network traffic:

function p () {
if [ -f Datadisk/*.pcap ]
then for i in $(find Datadisk -name *.pcap ) ;do echo " Pcap files  found, Printing info:" && echo $i && ls -lh $i| grep ".pcap" | awk '{print "File Size: " $5}' ;done
else 
echo "Pcap file doesn't exist"
fi
}
p

#Using Strings tool to check for  human readable text and save it into a directory :
echo "Carving with Strings :) "
strings $path | grep -i ".exe " >> Data/Stringinfo.txt
strings $path | grep -i "user" >> Data/Stringinfo.txt
strings $path | grep -i "password " >> Data/Stringinfo.txt

#Running Volatility commands:
function vol () {
voli=$(./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $path imageinfo | grep -i "suggested profile" | awk '{print $4}' | cut -d ',' -f1) 
./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $path --profile=$voli pstree >> Data/sami.txt
./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $path --profile=$voli netscan >> Data/sasi.txt
./volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $path --profile=$voli userassist >> Data/sani.txt

}
vol


#Final Results:
function res () {
echo -e "$(date)" 
if [ $ng -eq 1 ] 
then 
echo -e "Found "$(ls -lR Data/* | grep -v "^$" | wc -l )" Files while carving"  
echo -e "Forensic Analysis for file in path - [$path]" >> reported.txt
echo -e "Found "$(ls -lR Data/* | grep -v "^$" | wc -l )" Files while carving"  >> reported.txt
zip -r Datazip Data reported.txt >/dev/null
echo "All files has been zipped"
elif [ $ng -eq 2 ]
then
echo -e "Found "$(ls -lR Datadisk/* | grep -v "^$" | wc -l )" Files while carving"  
echo -e "Forensic Analysis for file in path - [$path]" >> report.txt
echo -e "Found "$(ls -lR Datadisk/* | grep -v "^$" | wc -l )" Files while carving"  >> report.txt
zip -r Datadiskzip Datadisk report.txt >/dev/null
echo "All files has been zipped"
fi
}
res
