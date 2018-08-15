#SingleInstance Force

#Include ModeSwitch.ahk
#Include functions.ahk
#Include kafka.ahk
#F1::
	SwitchTo("AutoHotKey.ahk")
return

#F5::
	SwitchTo("Qlikview.ahk")
return

#F6::
	SwitchTo("HBASE.ahk")
return

#F7::
	SwitchTo("zookeeper.ahk")
return


;~ #F7::
	;~ SwitchTo("Qlikview.ahk")
;~ return


#F12::
    Run, autohotkey.exe CountDown.ahk
return

 #!r::
	Reload
	ToolTip, Main reloading
	SetTimer, RemoveToolTip, 2000	
 return
 
 #Numpad4::
    Run, "C:/Users/qz55554/AppData/Local/Programs/jdk-10.0.2/bin/jshell.exe"
 return

;Under Test Management Repo for quick access items
#Numpad9::
    Send, ^c
    ClipWait    
    CourseKey := Clipboard    
    ;MsgBox,%CourseKey%
    Run, "C:\Users\qz55554\Documents\Visual Studio 2013\Projects\AdvantureWork\RepoCLI\bin\Debug\RepoCLI.exe" "Search" %CourseKey%
    Sleep, 1000
    ToolTip, %Clipboard%
    SetTimer, RemoveToolTip, 2000	
return

#Numpad8::
    Send, ^c
    ClipWait    
    CourseKey := Clipboard  
    Run, "C:\Users\qz55554\Documents\Visual Studio 2013\Projects\AdvantureWork\RepoCLI\bin\Debug\RepoCLI.exe" "Add" %CourseKey%
    Sleep,1000
    ToolTip, %Clipboard%
    SetTimer, RemoveToolTip, 2000	
return

;TSQL Formatter
#Numpad7::
    Send, ^c
    ClipWait    
    CourseKey := Clipboard 
    run, "C:\Users\qz55554\Documents\Visual Studio 2013\Projects\AdvantureWork\SQLFormatter\bin\Release\SQLFormatter.exe"
    Sleep, 1000
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

#!1::
    run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe
    WinWaitActive, MINGW64:/c/Users/qz55554/Documents/MyScripts, , 2
    WinActivate, MINGW64:/c/Users/qz55554/Documents/MyScripts
    SendInput, cd ~/Source/Repo/datasphere.ssis/Fauna.DB2014`n
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

#F4::
IfWinNotExist ahk_class SciTEWindow
{
    run, "C:\Users\qz55554\Documents\MyScripts\SciTE\SciTE.exe"
}else
{
     IfWinActive, ahk_class SciTEWindow
    {
        WinMinimize, ahk_class SciTEWindow
    }
    else
    {
        WinActivate, ahk_class SciTEWindow
    }
}
return



/*
    Credential Section
*/

^#k::
    SendRaw,ADMIN`tKYLIN`r
return

^#a::
    Credential := GetCredential("Me")
    SendRaw, %Credential%  
Return


^#u::
    Credential := GetCredential("Me","u")
    SendRaw %Credential%
RETURN

^#p::
    Credential := GetCredential("Me","p")
    SendRaw %Credential%
Return

^#g::
    SendRaw gsmspark`tgsmspark`r
    ;SendRaw gsmspark`tgsm_476338`r
Return