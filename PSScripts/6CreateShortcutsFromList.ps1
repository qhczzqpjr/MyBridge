[CmdletBinding()]
param(
    $ConfigFilePath="$(pwd)\6ItemLists.txt",
    $Splitor = ";",
    $targetfolder="$(pwd)\",
    $LogFileName = "$(pwd)\6CreateShortcutsFromListLog.txt"
)

$FileCopyStatus=@{}

Get-Content $ConfigFilePath | ForEach-Object {

  Try {
    $targetPathName = $_.ToString().Split($Splitor)[0].ToString();
    $sourcePath = $_.ToString().Split($Splitor)[1].ToString(); 
    $targetPath =  $targetfolder+$targetPathName+".lnk"

    $Shell = New-Object -ComObject ("WScript.Shell")
    if (Test-Path $targetPath)
    {
        Remove-Item $targetPath
    }
    $ShortCut = $Shell.CreateShortcut($targetPath)
    $ShortCut.TargetPath=$sourcePath
    $ShortCut.WindowStyle = 1;
    #$ShortCut.Arguments="-arguementsifrequired"
    #$ShortCut.WorkingDirectory = "c:\your\executable\folder\path";
    #$ShortCut.Hotkey = "CTRL+SHIFT+F";
    #$ShortCut.IconLocation = "yourexecutable.exe, 0";
    $ShortCut.Description = "Your Custom Shortcut Description";
    $ShortCut.Save()
    }
    Catch {
        $FileCopyStatus.Add("$targetfolder", "Failure")
        Write-Host "Failure: $targetfolder"
        #$ErrorMessage = $_.Exception.Message
        #$FailedItem = $_.Exception.ItemName
    }  
    
}

 $FileCopyStatus.GetEnumerator() | % {
    $FileName = $_.Key
    $FileStatus = $_.Value

    "$FileName : $FileStatus " | Out-File -Append -FilePath $LogFileName -Encoding ascii
}