[CmdletBinding()]
param(
    $ConfigFilePath="$(pwd)\*",
    $pattern = "([A-Z0-9._%+-]+@[A-Z0-9._%+-]+)",
    $OutputPath ="$(pwd)\test.txt",
    $LogFileName = "$(pwd)\5GetMatchPatternFromFile.txt"
)

"Start" 
"Start" >>$LogFileName

gci $ConfigFilePath -Recurse -File | ForEach-Object { 
$f = $_.FullName;
$d = (Get-Content $f -Raw);
if($d -match $pattern){
    "{0}`t{1}" -f $f, $Matches[0] >> $OutputPath
    }
}
"Done"
"Done">>$LogFileName