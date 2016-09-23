
[CmdletBinding()]
param(
    $ConfigFilePath="$(pwd)\2filelist.txt",
    $Splitor = ";",
    $LogFileName = "$(pwd)\2CopyFilesFromFilelog.txt"
)


$FileCopyStatus=@{}


Get-Content $ConfigFilePath | ForEach-Object {
        $itemToCopy = $_.ToString().Split($Splitor)[0].ToString();
        $ItemToSave = $_.ToString().Split($Splitor)[1].ToString();
        $targetfolder = Split-Path $ItemToSave -Parent;
        

        #If destination folder doesn't exist
        if (!(Test-Path $targetfolder -PathType Container)) {
            #Create destination folder
            New-Item -Path $targetfolder -ItemType Directory -Force
        }
        Try {
            Copy-Item -Path $itemToCopy -Destination $ItemToSave 
            $FileCopyStatus.Add("$itemToCopy", "Success")
            Write-Host "Success: $itemToCopy"
        }
        Catch {
           $FileCopyStatus.Add("$itemToCopy", "Failure")
           Write-Host "Failure: $itemToCopy"
           #$ErrorMessage = $_.Exception.Message
           #$FailedItem = $_.Exception.ItemName
        }      
    }

 $FileCopyStatus.GetEnumerator() | % {
    $FileName = $_.Key
    $FileStatus = $_.Value

    "$FileName : $FileStatus " | Out-File -Append -FilePath $LogFileName -Encoding ascii
}
 