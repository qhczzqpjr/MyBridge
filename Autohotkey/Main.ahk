#SingleInstance Force

#Include ModeSwitch.ahk


#F1::
	SwitchTo("AutoHotKey.ahk")
return



#F5::
	SwitchTo("PAA.ahk")
return


 #!r::
	Reload
	ToolTip, Main reloading
	SetTimer, RemoveToolTip, 2000	
 return
 
 
 #1::
    run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe
    WinWaitActive, MINGW64:/c/Users/qz55554/Documents/MyScripts, , 2
    WinActivate, MINGW64:/c/Users/qz55554/Documents/MyScripts
    SendInput, cd ~/Source/Repo/datasphere.tsql/Tsql.speeddb/`n
    SendInput, git status`n
    SendInput, git pull`n
    SendInput, ls`n
return
#+1::
    run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe
    WinWaitActive, MINGW64:/c/Users/qz55554/Documents/MyScripts, , 2
    WinActivate, MINGW64:/c/Users/qz55554/Documents/MyScripts
    SendInput, cd ~/Source/Repo/gsmspark.all/`n
    SendInput, git status`n
    SendInput, git pull`n
    SendInput, ls`n
return
#!1::
    run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe
    WinWaitActive, MINGW64:/c/Users/qz55554/Documents/MyScripts, , 2
    WinActivate, MINGW64:/c/Users/qz55554/Documents/MyScripts
    SendInput, cd ~/Source/Repo/datasphere.ssis/Fauna.DB2014`n
    SendInput, git status`n
    SendInput, git pull`n
    SendInput, ls`n
return
