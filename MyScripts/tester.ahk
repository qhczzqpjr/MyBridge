#SingleInstance force



^!a::
    Credential := GetCredential("Me")
    SendRaw, %Credential%  
Return

#a:: ;Autosys
    
    Sleep,333
    send, ^c
    ClipWait
    AutosysJobName := Clipboard
    TargetUrl := "https://tiawccap001swq.nam.nsroot.net:10157/QuickView/pages/main.jsf?serverName=PA6&displayMode=inFrame&jobName=" AutosysJobName "&conversationContext=1"
    Run, %TargetUrl%
    Sleep, 2000
    IfWinExist, Login - CA Workload Control Center - Google Chrome ahk_class Chrome_WidgetWin_1
    {
        WinWaitActive, Login - CA Workload Control Center - Google Chrome ahk_class Chrome_WidgetWin_1
        Sleep, 333
        Credential := GetCredential("Me")
        SendRaw, %Credential% 
    }
return









GetCredential(x, y="")
{
	if ( x ="Me")
	{
		if (y="u")
		{
			return ""
		}
		if (y="p")
		{
			return ""
		}
		if (y="")
		{
			return ""
		}
	}else if (x="Sys")
	{
		if (y="u")
		{
			return "speed_it`t"
		}
		if (y="p")
		{
			return "Welcome2`r"
		}
		if (y="")
		{
			return "speed_it`tWelcome2`r"
		}
		
	}else if (x="Jks")
	{
		return "admin`tadmin123`r"
	}
	
	
}