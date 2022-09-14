# fileReport
Report on and email a report for files matching a particular date.
<br><br>
Finds the files that were created, born, or accessed on a particular day.
 - By default, pulls for the current day.  Edit $month, $day, $year to adjust.
 - By default, searches for modified files using stat.  This can be adjusted 
  to pull files born or accessed on the specified date as well.
<br>
Finally, generates reports of all discovered files in the specified
  directory (including all of its sub-directores) and another report on
  details for files used/born/accessed on the specified date.<br><br>
These reports are also archived in fileList-bak/ in the directory from which it
   is run. The details for files matching the specified date are also emailed
   to the email specified.<br><br>

## REQUIREMENTS:
 - sendmail and mailx configured properly to send emails.
 
## INPUTS:
 - $1 = directory to search for files in
 - $2 = email to send reports to

## EXAMPLE:
```
$ ./fileReport.sh /tmp/file-dir/ yourself@email.com
fullDir = /tmp/file-dir/
simpleDir = tmp-file-dir
Getting full file list
Now, finding files modified on 09/14/2022 in directory /tmp/file-dir/
emailing results...
err4
cleaning up...
```
## SAMPLE REPORT:
```
$ cat fileList-bak/detailedFileList-tmp-file-dir-09-14.txt 
2022-09-14 07:31:12 ---> /tmp/file-dir/test.txt
2022-09-14 07:32:41 ---> /tmp/file-dir/test2.txt
```
