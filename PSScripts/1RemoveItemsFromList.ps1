[CmdletBinding()]
param(
    $ConfigFilePath="$(pwd)\1ItemLists.txt",
    $Action=0,#0-Create,1-Delete,2-Merge
    $LogFileName = "$(pwd)\1RemoveItemsFromList.txt"
)

$FileCopyStatus=@{}


Get-Content $ConfigFilePath | ForEach-Object {
        
        $targetfile = $_.ToString();


        Try {
            if (Test-Path $targetfile) {
                Remove-Item $targetfile
                    
                $FileCopyStatus.Add("$targetfile", "Success")
                Write-Host "Success: $targetfile"
            }

            $FileCopyStatus.Add("$targetfile", "No Such File")
                Write-Host "No Such File: $targetfile"
        }
        Catch {
           $FileCopyStatus.Add("$targetfile", "Failure")
           Write-Host "Failure: $targetfile"

        }      
    }


 $FileCopyStatus.GetEnumerator() | % {
    $FileName = $_.Key
    $FileStatus = $_.Value

    "$FileName : $FileStatus " | Out-File -Append -FilePath $LogFileName -Encoding ascii
}
 