
<#
    This script allows for a controlled start-up of mongodb, with logging output going to both console and logfile.
    Logfile will be rotated on each startup, renaming the previous file with the next start-up datetime.
#>

$binPath = 'C:\Program Files\MongoDB\Server\3.0\bin';
$exeName = 'mongod.exe';
$confPath = 'C:\Program Files\MongoDB\Server\3.0\conf\mongodb.conf';
$logPath = 'C:\data\mongodb\log\mongodb.log';

$mongoLockPath = 'C:\data\mongodb\mongod.lock';

$datePath = $timestamp = Get-Date -Format o | foreach {$_ -replace ":", "."}

if((Test-Path $logPath -PathType Leaf) -eq $true){
    #Logfile exists so we'll rename it
    Rename-Item $logPath -NewName "mongodb.$datePath.log"
} 

#TODO: we could test for the number of *.logs in this path and trim to a specific number or to a specific size criteria (e.g. < 10MB)

#check for the mongod.lock and delete if it exists. If not deleted, the database startup could bog down or even halt
gci $mongoLockPath | Remove-Item -Force

#Tee-Object splits the std output to both console and logfile
. $binPath\$exeName -f $confPath | Tee-Object -FilePath $logPath