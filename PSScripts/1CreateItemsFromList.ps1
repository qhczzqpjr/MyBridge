[CmdletBinding()]
param(
    $ConfigFilePath="$(pwd)\1ItemLists.txt",
    $Action=0,#0-Create,1-Delete,2-Merge
    $LogFileName = "$(pwd)\1CreateItemsFromList.txt"
)

$FileCopyStatus=@{}


Get-Content $ConfigFilePath | ForEach-Object {
        
        $targetfolder = $_.ToString();


        Try {
            if($Action -eq 0){
                #If destination folder doesn't exist
                if (!(Test-Path $targetfolder -PathType Container)) {
                    #Create destination folder
                    New-Item -Path $targetfolder -ItemType Directory -Force
                }
                Write-Host "Success: $targetfolder"
            }

             if($Action -eq 1){
                #If destination folder doesn't exist
                if (Test-Path $targetfolder -PathType Container) {
                    #Create destination folder
                    Remove-Item -Path $targetfolder -Force -Recurse
                }
                Write-Host "Success: $targetfolder"
            }

             if($Action -eq 2){
                #If destination folder doesn't exist
                if (Test-Path $targetfolder -PathType Container) {
                    #Create destination folder
                    New-Item -Path $targetfolder -ItemType Directory -ErrorAction SilentlyContinue
                }
                Write-Host "Success: $targetfolder"
            }
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
 