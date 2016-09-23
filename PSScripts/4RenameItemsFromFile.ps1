
[CmdletBinding()]
param(
    $ConfigFilePath="$(pwd)\4filelist.txt",
    $Splitor = ";",
    $LogFileName = "$(pwd)\4RenameItemsFromFileLog.txt"
)


$FileRenameStatus=@{}


Get-Content $ConfigFilePath | ForEach-Object {
        $itemToRename = $_.ToString().Split($Splitor)[0].ToString();
        $ItemToSave = $_.ToString().Split($Splitor)[1].ToString();
        $NewName = Split-Path $ItemToSave -Leaf;
        if (!(Test-Path $itemToRename)) {
            $FileRenameStatus.Add("$itemToRename", "Failure")
            Write-Host "Failure: $itemToRename"
            return
        }
        Try {
           
            Rename-Item -Path $itemToRename -NewName $NewName
            
            $FileRenameStatus.Add("$itemToRename", "Success")
            Write-Host "Success: $itemToRename"
        }
        Catch {
           $FileRenameStatus.Add("$itemToRename", "Failure")
           Write-Host "Failure: $itemToRename"
           #$ErrorMessage = $_.Exception.Message
           #$FailedItem = $_.Exception.ItemName
        }      
    }

 $FileRenameStatus.GetEnumerator() | % {
    $FileName = $_.Key
    $FileStatus = $_.Value

    "$FileName : $FileStatus " | Out-File -Append -FilePath $LogFileName -Encoding ascii
}
 