<##########################################################################################

This script is used to execute sql scripts

##########################################################################################>

#

[CmdletBinding()]
param(
    [ValidateSet("DEV", "UAT", "PROD")]
    $EnvStr,
    $RootPath ="$(pwd)",
    $CurrDBName ="LP",
    $LogFileName = "$(pwd)\0DeploySqlscriptsLog.txt"
)
 
$DBInfo = @{

    'DEV' = @{
        'ServerName'=''
        'UserName' = ''
        'Password' = ''
        'IsWinAuth' = $false
    }

    'UAT' = @{
        'ServerName'=''
        'UserName' = ''
        'Password' = ''
        'IsWinAuth' = $false
    }
    
    'Prod' = @{
        'ServerName'=''
        'UserName' = $null
        'Password' = $null
        'IsWinAuth' = $true
    }
}

$SqlDeployStatus=@{}

Get-ChildItem $RootPath | % {
                
        $FileFullName = $_.FullName
        $CurrDBName
        $DBInfo[$EnvStr].Password
        $DBInfo[$EnvStr].UserName
        $DBInfo[$EnvStr].ServerName
        $FileFullName
        
       if($DBInfo[$EnvStr].IsWinAuth -eq $true) {
           sqlcmd.exe -b -S $DBInfo[$EnvStr].ServerName -d $CurrDBName -E -i $FileFullName
       }
       else {
           sqlcmd.exe -b -S $DBInfo[$EnvStr].ServerName -d $CurrDBName -U $DBInfo[$EnvStr].UserName -P $DBInfo[$EnvStr].Password -i $FileFullName
       }
       
       if($LASTEXITCODE -eq 0) {
           $SqlDeployStatus.Add("$FileFullName", "Success")
           Write-Host "Success: $FileFullName"
       }
       else {
           $SqlDeployStatus.Add("$FileFullName", "Failure")
           Write-Host "Failure: $FileFullName"
       }
}

 $SqlDeployStatus.GetEnumerator() | % {
    $FileName = $_.Key
    $FileStatus = $_.Value

    "$FileName : $FileStatus " | Out-File -Append -FilePath $LogFileName -Encoding ascii

 }