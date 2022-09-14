#!/bin/bash
# Finds the files that were created, born, or accessed on a particular day.
#  By default, pulls for the current day.  Edit $month, $day, $year to adjust.
#  By default, searches for modified files using stat.  This can be adjusted 
#   to pull files born or accessed on the specified date as well.
#  Finally, generates reports of all discovered files in the specified
#   directory (including all of its sub-directores) and another report on
#   details for files used/born/accessed on the specified date.
#  These reports are archived in fileList-bak/ in the directory from which it
#    is run. The details for files matching the specified date are also emailed
#    to the email specified.
#
# REQUIREMENTS: sendmail and mailx configured properly to send emails.
# 
# INPUTS:
#  $1 = directory to search for files in
#  $2 = email to send reports to
#  
# Author: Aaron Dhiman
# Version: 0.3
set +e
######## VARS ###############
fullDir="$1"
email=$2
#echo $fullDir
simpleDir=`echo $fullDir | tr '/' '-'`
simpleDir=`echo $simpleDir | sed 's/^-//'`
simpleDir=`echo $simpleDir | sed 's/-$//'`
echo fullDir = $fullDir
echo simpleDir = $simpleDir
email=$2
month=`date +%m`
day=`date +%d`
year=`date +%Y`
basicFileList=basicFileList-$simpleDir-$month-$day.txt
fileStatList=filesStat-$simpleDir-$month-$day.txt
detailedFileList=detailedFileList-$simpleDir-$month-$day.txt
#############################
echo Getting full file list
touch $basicFileList
sudo find $fullDir -type f | sort -nr > $basicFileList 
echo err1 = $?
# exclude the following paths:
sed -i '/firefox/d;/chromium/d;/elasticsearch/d;/google-chrome/d;/.steam/d;/.cache/d;/.mozilla/d;/.local/d' $basicFileList
echo err2 = $?
touch $fileStatList 
touch $detailedFileList
echo Now, finding files modified on $month/$day/$year in directory $fullDir
while read myLine; do
  currFile=`sudo stat --printf="%z ------> %n" "$myLine"`
  echo $currFile >> $fileStatList
done <$basicFileList
grep $year-$month-$day $fileStatList > $detailedFileList 
sed -i 's/\(^.*\)\..*\(---.*\)/\1 \2/' $detailedFileList   # strip off extra timestamp stuff
echo err3 = $?
echo emailing results...
cat $detailedFileList | mail -s "Today's New Files on `hostname` in directory $fullDir" $email 
echo err4 = $?
echo cleaning up...
mv *.txt fileList-bak/

