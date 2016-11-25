"Start" >> test.log
hostname >> test.log
$i = (Get-Date -Format yyyyMMddHHmmss).ToString()
$path = Join-Path -Path "C:\Users\qz55554\Desktop\test" $i".txt"
$path >> test.log
New-Item -Path $path 
"End" >> test.log
"-----------" >> test.log
