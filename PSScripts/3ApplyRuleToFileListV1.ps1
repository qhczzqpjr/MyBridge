﻿
[CmdletBinding()]
param(
    $TargetFile="$(pwd)\3FileListV1.txt",
    $RuleFilePath="$(pwd)\3ReplaceRule.txt",
    $LogFileName = "$(pwd)\3ApplyRuleToFileListV1Log.txt"
)


$FileCopyStatus=@{}
$FileRule=@{}


Try {

    Get-Content $RuleFilePath | ForEach-Object {$tmp = $_.ToString().Split("|") ; $FileRule.Add($tmp[0],$tmp[1])}

    $file = Get-Content $TargetFile

    $FileRule.GetEnumerator() | % {
        $file = $file.Replace($_.Key,$_.Value)
    } 

    Set-Content -Path $TargetFile  -Value $file

        $FileCopyStatus.Add("$TargetFile", "Success")
        Write-Host "Success: $TargetFile"

}
Catch
{
        $FileCopyStatus.Add("$TargetFile", "Failure")
        Write-Host "Failure: $TargetFile"
}


 $FileCopyStatus.GetEnumerator() | % {
    $FileName = $_.Key
    $FileStatus = $_.Value

    "$FileName : $FileStatus " | Out-File -Append -FilePath $LogFileName -Encoding ascii
}
 