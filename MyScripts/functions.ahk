GetCredential(x, y="")
{
	if ( x ="Me")
	{
		if (y="u")
		{
			return "qz55554`t"
		}
		if (y="p")
		{
			return "Infy123+08`r"
		}
		if (y="")
		{
			return "qz55554`tInfy123+08`r"
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
	}else if (x="eMBS")
	{
		return "tzhu1`t53sidex`r"
	}else if (x="Spark")
	{
		return "infy,123"
	}else if(x="cloud")
	{
		return "EMER_QZ55554`t `r"
	}
	
	
}

BindProgram(Program, Exe)
{
	IfWinNotExist ahk_class %Program%
	{
		run, %Exe%
	}else
	{
		 IfWinActive, ahk_class %Program%
		{
			WinMinimize, ahk_class %Program%
		}
		else
		{
			WinActivate, ahk_class %Program%
		}
	}
	return
}