#SingleInstance force

#Include functions.ahk
#Include Class_SQLiteDB.ahk


SetWorkingDir %A_ScriptDir%

#Persistent

; Save the file every ten minutes.
SetTimer, AutoSave, 600000, On

AutoSave:
    run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe
    WinWaitActive, MINGW64:/c/Users/qz55554/Documents/MyScripts, , 2
    WinActivate, MINGW64:/c/Users/qz55554/Documents/MyScripts
    SendInput, cd ~/Source/github/MyBridge/`n 
    SendInput, git pull`n
    Sleep, 10000 
    Run, powershell "C:\Users\qz55554\Source\github\MyBridge\Mycmd.ps1"
    WinActivate, MINGW64:/c/Users/qz55554/Source/github/MyBridge
    SendInput, git add -A `n
    Sleep, 10000
    WinActivate, MINGW64:/c/Users/qz55554/Source/github/MyBridge
    SendInput, git commit -m "auto" `n
    Sleep, 10000
    WinActivate, MINGW64:/c/Users/qz55554/Source/github/MyBridge
    SendInput, git push`n
    Sleep, 10000
    WinActivate, MINGW64:/c/Users/qz55554/Source/github/MyBridge
    SendInput, exit`n
return

!F1::
    MsgBox, Stop timer
    ExitApp
return