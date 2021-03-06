#Author: Nick Novotny

#Date: December 2015
Updated: September 2016
Updated: August 2019

#Name: Forenzix Investigation Script to:
#1. hash an existing hard disk
#2. capture the existing hard disk using dd
#3. hash the capture for verification
#4. Convert the raw capture of the hard disk to a vmdk virtual hard disk format
#5. Create a VM from using the newly created vmdk
#6. Start the VM for inspection of traffic and function

#This script was designed for Forenzix (a Linux distro under development to document and capture an evidence disk, then virtualize it and connect it to an isolated or simulated information gathering tool and observe the suspected malware-infected machine's operation. 

#This script assumes that it is being run on either Kali in Forensics Mode installed on

#one partition of a dual partition USB drive.  That USB drive should have 1 partition with Kali and the other is used to store the evidence captures.  This script assumes that the second (evidence capture) partition is mounted in /mnt/ev.

#This script assumes (for the first released version) that there is no persistence setup in the Kali live iso.

#Specify bash as the appropriate shell to use

#!/bin/bash

#This script will reside on a non-persistent live USB, therefore all packages must be installed prior to the

#investigation beginning.

#echo ${devices[0]} This was used for troubleshooting my array listing.  Troubleshooting is complete.
echo "Available disks to capture:"

#List on the screen all available hard disks for investigator to capture

#first list all disks detected by Linux with labels and sizes.
sudo lsblk -o name,label,size | tee -a $casename

counter=1

#Then list for selection
for d in ${devices[@]}
do
echo $counter") " $d
counter=`expr $counter + 1`
done
#end for loop

#take investigator input for device to capture
echo "Please enter which device would you like to capture, then press [ENTER]"
#User enters a number to represent the disk which the investigator desires to capture. 
read disk

#ask investigator for name of case
echo "What would you like to call this case? Your casename should have no spaces.  If spaces are included, the script will error out."
read userinputname
casename=$userinputname"Notes.notes"

#change to the evidence capture mount
cd /mnt/ev

#create investigation file
touch $casename

#echo investigation start, date, time, etc. to investigation notes.

echo "Investigation started at:" | tee -a $casename
date | tee -a $casename

#echo disks detected, currently this script is written for Kali/Debian

echo "${devices[$disk-1]} is designated as evidence." | tee -a $casename

#echo $hash_method, $hash | tee -a $casename
date | tee -a $casename

echo "MD5 hash value:" | tee -a $casename
date | tee -a $casename
md5sum ${devices[$disk-1]} | tee -a $casename
date | tee -a $casename


echo "SHA1 hash value:" | tee -a $casename
date | tee -a $casename

sha1sum ${devices[$disk-1]} | tee -a $casename
date | tee -a $casename


echo "SHA256 state of Evidence:" | tee -a $casename
date | tee -a $casename

sha256sum ${devices[$disk-1]} | tee -a $casename
date | tee -a $casename

#capture disk bit-for-bit using dd showing progress which should give the user the ability to estimate time to completion.
echo "Now capturing the evidence disk..." | tee -a $casename
date | tee -a $casename
3dd bs=1 if=${devices[$disk-1]} of=capture.raw status=progress


#echo disk captured, $hash_value

echo "Capture process completed." | tee -a $casename

date | tee -a $casename

echo "Capture completed." | tee -a $casename
date | tee -a $casename

echo "Now verifying capture" | tee -a $casename

#echo "Evidence state (md5sum):"  | tee -a $casename

#md5deep ${devices[$disk-1]} | tee -a $casename
#date | tee -a $casename
#echo "Capture state MD5:" | tee -a $casename
#md5sum capture.raw | tee -a $casename

echo "Captures MD5 hash value:" | tee -a $casename
date | tee -a $casename

md5sum capture.raw | tee -a $casename
date | tee -a $casename
#echo "Capture completed." | tee -a $casename
#date | tee -a $casename


echo "Captures SHA1 hash value:" | tee -a $casename
date | tee -a $casename
sha1sum capture.raw | tee -a $casename
date | tee -a $casename

echo "Captures SHA256 hash value:" | tee -a $casename
date | tee -a $casename
echo "Capture completed." | tee -a $casename
date | tee -a $casename

echo "Do you wish to continue to the vmdk conversion and verification process now?(CAUTION: this process will take several hours) (y/N)"
read answer

echo $answer

if [ "$answer" = "y" ];
then

echo "true"

./virtualize.sh

fi

echo "This investigation must continue using this tool on another computer to convert the raw file to vmdk format." | tee -a $casename

exit 0

#echo that raw will be converted to vmdk format

#echo "the raw dump will be converted to vmdk format." | tee >> $casename

#echo "vmdk conversion started." | tee >> $casename

#date | tee >> $casename

#qemu-img convert -f raw capture.raw -O vmdk capture.vmdk

#echo "vmdk conversion completed." | tee >> $casename

#date | tee >> $casename

#echo $hash_method, $hash_value of raw format

#echo "vmdk files MD5 hash(md5deep):" | tee >> $casename

#date | tee >> $casename

#md5deep capture.vmdk | tee >> $casename

#date | tee >> $casename

#echo "vmdk files MD5 hash(md5sum):" | tee >> $casename

#md5sum capture.vmdk | tee >> $casename

#date | tee >> $casename

#echo "vmdk files MD5 hash(md5deep):" | tee >> $casename

#md5deep capture.vmdk | tee >> $casename

#echo "vmdk files MD5 hash(md5sum):" | tee >> $casename

#md5sum capture.vmdk | tee >> $casename

#echo "vmdks SHA1 Hash:" | tee >> $casename

#date | tee >> $casename

#sha1deep capture.vmdk | tee >> $casename

#date | tee >> $casename

#echo "vmdks SHA1 Hash Value:" | tee >> $casename

#sha1deep capture.vmdk | tee >> $casename

#echo converting back to raw format

#echo "VMDK verification being performed. Converting back to raw to verify." | tee >> $casename

#echo "VMDK verification being performed. Converting back to raw to verify."

#date | tee >> $casename

#qemu-img convert -f vmdk capture.vmdk -O raw capture1.raw

#echo "vmdk->raw conversion completed." | tee >> $casename

#date | tee >> $casename

#echo "vmdk->raw conversion completed." | tee >> $casename

#echo $hash_method, $hash_value of raw converted disk

#echo "MD5 hash of converted raw file(md5deep):" | tee >> $casename

#date | tee >> $casename

#md5deep capture1.raw | tee >> $casename

#date | tee >> $casename

#echo "MD5 hash of converted raw file(md5sum):" | tee >> $casename

#date | tee >> $casename

#md5sum capture1.raw | tee >> $casename

#date | tee >> $casename

#echo "MD5 hash of converted raw file(md5deep):" | tee >> $casename

#md5deep capture1.raw | tee >> $casename

#date | tee >> $casename

#echo "MD5 hash of converted raw file(md5sum):"

#md5sum capture1.raw

#hash verified (hopefully)

#echo "Capture completed.  VM starting." | tee >> $casename

#date | tee >> $casename
