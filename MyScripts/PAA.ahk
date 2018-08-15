#SingleInstance force

Run, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Excel 2016.lnk" C:\Users\qz55554\Desktop\PAA\PAAExpert.xlsx
;Check PAA incoming data	
Run, explorer.exe \\csmspdnadbpr01\Speed\Data\PAA
Run, explorer.exe \\rutvnaspol0001\speednas\Data\PAA

;Check PAA output data	
Run, explorer.exe \\speedapp\speed\Data\PAA\PAAFeedToS2\
;Check PAA temp folder local	
Run, explorer.exe C:\Users\qz55554\Desktop\PAA
;Check Speed.Batch configure	
Run, explorer.exe \\speedapp\Speed\Services\SpeedBatchService
;Check PAA.Batch configure	
Run, explorer.exe \\speedapp\Speed\Apps\PaaBatch


Run, explorer.exe https://cedt-confluence.nam.nsroot.net/confluence/display/156762/PAA
