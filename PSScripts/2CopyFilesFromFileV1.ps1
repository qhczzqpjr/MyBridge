
[CmdletBinding()]
param(
    $ConfigFilePath="$(pwd)\2filelistV1.txt",
    $targetFolder="$(pwd)\2CopyFilesFromFileV1Output\",
    $LogFileName = "$(pwd)\2CopyFilesFromFileV1Log.txt"
)


$FileCopyStatus=@{}
 

Get-Content $ConfigFilePath | ForEach-Object {
        $itemToCopy = $_.ToString();
        $sourceFolderName = Split-Path $itemToCopy -Parent;
        $targetPathAndFile =  $itemToCopy.Replace( $sourceFolderName , $targetFolder );

        #If destination folder doesn't exist
        if (!(Test-Path $targetfolder -PathType Container)) {
            #Create destination folder
            New-Item -Path $targetfolder -ItemType Directory -Force
        }
        Try {
            Copy-Item -Path $itemToCopy -Destination $targetPathAndFile 
            $FileCopyStatus.Add("$itemToCopy", "Success")
            Write-Host "Success: $itemToCopy"
        }
        Catch {
           $FileCopyStatus.Add("$itemToCopy", "Failure")
           Write-Host "Failure: $itemToCopy"
        }      
    }

 $FileCopyStatus.GetEnumerator() | % {
    $FileName = $_.Key
    $FileStatus = $_.Value

    "$FileName : $FileStatus " | Out-File -Append -FilePath $LogFileName -Encoding ascii
}
 