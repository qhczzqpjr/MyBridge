AHKPanic(Kill=0, Pause=0, Suspend=0, SelfToo=0) {
DetectHiddenWindows, On
WinGet, IDList ,List, ahk_class AutoHotkey
Loop %IDList%
  {
  ID:=IDList%A_Index%
  WinGetTitle, ATitle, ahk_id %ID%
  IfNotInString, ATitle, %A_ScriptFullPath%
    {
    If Suspend
      PostMessage, 0x111, 65305,,, ahk_id %ID%  ; Suspend. 
    If Pause
      PostMessage, 0x111, 65306,,, ahk_id %ID%  ; Pause.
    If Kill
        IfNotInString, ATitle, SciTE ; exclude SciTE instance
            WinClose, ahk_id %ID% ;kill
    }
  }
If SelfToo
  {
  If Suspend
    Suspend, Toggle  ; Suspend. 
  If Pause
    Pause, Toggle, 1  ; Pause.
  If Kill
    ExitApp
  }
}


AHKRun(Name="Main.ahk"){
    Program= %A_ScriptDir%\%Name%
    Run, AutoHotkey.exe %Program%
	ToolTip, %Name% has started
	SetTimer, RemoveToolTip, 2000 
}


RemoveToolTip:
  SetTimer, RemoveToolTip, off
  ToolTip
return


SwitchTo(Name)	
{
    AHKPanic(1, 0, 0, 0)
	AHKRun()
	AHKRun(Name)	
}