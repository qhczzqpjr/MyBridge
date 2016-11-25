hostname #> test.log
$i = (Get-Date -Format yyyyMMddHHmmss).ToString() #> test.log
$path = Join-Path -Path "C:\Users\qz55554\Desktop\test" $i".txt"
New-Item -Path $path #> test.log
