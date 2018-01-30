;^ = Ctril
;+ = Shift
;! = Alt
;# Windows Key
#SingleInstance force
#Include functions.ahk
;https://tfs.citigroup.net/tfs
;~ Comment/UnComment Code Out - ^Q

;Global Variables
gMonitor:= "Dell"

;Quick TypeIn
::/e::explorer.exe .
::/st::select * from
::/stc::select Count(1) from
::/st10::select top 10 * from
::/sit::SELECT * FROM INFORMATION_SCHEMA.TABLES
::/stit::select * from information_schema.tables where table_schema + '.'+ table_name = ''
::/stic::select * from information_schema.columns where table_schema + '.' + table_name = '' and column_name like '%%'

::/sd::SELECT <key> FROM <table> GROUP BY <key> HAVING COUNT(1)>=2
::/sd1::select count(<key>)*1.0/ count(1) from <table>
::/spu::sp_spaceused 
::/sht::sp_helptext 

::/dt::drop table
::/ct::create table
::/oet::IF OBJECT_ID(N'','U') IS NOT NULL
::/oev::IF OBJECT_ID(N'','V') IS NOT NULL
::/oep::IF OBJECT_ID(N'','P') IS NOT NULL
::/oetc::IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '' AND COLUMN_NAME = '' AND TABLE_SCHEMA = 'dbo')
::/oei::IF EXISTS (SELECT 1 FROM sys.indexes WHERE NAME = '' AND OBJECT_ID = OBJECT_ID(N'','U'))
::/oeip::IF EXISTS (select 1 from sys.partitions p join sys.indexes i on p.index_id = i.index_id and p.object_id = i.object_id where i.name = '' and p.object_id = object_id('','U') and partition_number = )
::/sq::exec [sys].sp_describe_first_result_set N''
::/sq1::select * from sys.dm_exec_describe_first_result_set_for_object(OBJECT_ID(N'','P'), 0)

::/gcd::git checkout develop
::/gs::git status
::/gp::git pull
::/gpn::git push --set-upstream origin UserStory_
::/gps::git push
::/gcu::git checkout UserStory_
::/gcun::git checkout -b UserStory_
::/gb::git branch
::/gmd::git merge develop
::/gcm::git commit -m "
::/ppi::pip install  --proxy proxy.citicorp.com:8080
::/cmp::co00724
::/cmp1::100141409

::/call1::6820479425
::/call2::1241873064
::/call0::*2255
::/callit::041139778866
::/callp::3438470
::/mail::qian1.zhu@citi.com
::/mail0::mailhub-vip.nj.ssmb.com
::/proxy::proxy.citicorp.com:8080

^+c::
; null= 
send ^c
sleep,200
clipboard=%clipboard% ;%null%
tooltip,%clipboard%
sleep,500
tooltip,
return

^#c::
MouseGetPos, mouseX, mouseY
PixelGetColor, color, %mouseX%, %mouseY%, RGB
StringRight color,color,6
clipboard = %color%
return

;IfWinActive, Protal ahk_class AutoHotkeyGUI {  }
#a:: ;Autosys
    Sleep,333
    send, ^c
    ClipWait
    AutosysJobName := Clipboard
    ;TargetUrl := "https://tiawccap001swq.nam.nsroot.net:10157/QuickView/pages/main.jsf?serverName=PA6&displayMode=inFrame&jobName=" AutosysJobName "&conversationContext=1"
    TargetUrl := "https://tiajawap004swp.nam.nsroot.net:8443/wcc/login/applicationLogin.faces"
    Run, %TargetUrl%
    Sleep, 2000
    ;~ IfWinExist, Login - CA Workload Control Center - Google Chrome ahk_class Chrome_WidgetWin_1
    ;~ {
        ;~ WinWaitActive, Login - CA Workload Control Center - Google Chrome ahk_class Chrome_WidgetWin_1
        ;~ Sleep, 333
        ;~ Credential := GetCredential("Me")
        ;~ SendRaw, %Credential% 
    ;~ }
    IfWinExist, WCC5 - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        WinWaitActive, WCC5 - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
        Sleep, 333
        Credential := GetCredential("Me")
        SendRaw, %Credential%
        Sleep, 2333
        MouseClick,left,545,170
    }
return

#!a:: ;Autosys
    
    Sleep,333
    send, ^c
    ClipWait
    AutosysJobName := Clipboard
    TargetUrl := "https://tiawccap012mwp.nam.nsroot.net:8443/wcc/ui/Login.html"
    Run, %TargetUrl%
    Sleep, 2000
    IfWinExist, CA Workload Automation - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        WinWaitActive, CA Workload Automation - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
        Sleep, 333
        Credential := GetCredential("Me")
        SendRaw, %Credential% 
    }
    Sleep,5000
    IfWinExist, CA Workload Automation (tiawccap012mwp) - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        WinWaitActive, CA Workload Automation (tiawccap012mwp) - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
        MouseClick,left, 250,160
        Sleep, 2000
        MouseClick,left, 1050,265
        SendInput, %AutosysJobName%`r
    }
return

#b:: ;window bar
    send, ^c
    Sleep, 333
    run, explorer.exe %Clipboard%
return

#c:: ;vim
   run, C:\Users\qz55554\Source\github\gvim.exe.lnk
return

;#d:: ;windows Desktop

#e:: ;Apply Leave
	TargetUrl := "https://citi.tms.east.citigroup.net/ctmseast/#"
    Run, %TargetUrl%
    WinWaitActive, Single Sign-On - Google Chrome ahk_class Chrome_WidgetWin_1
    Sleep, 333
	Credential := GetCredential("Me")
    SendRaw, %Credential%
return

#f:: ;Fauna - invalid
    run, https://tfs.citigroup.net/tfs/Jupiter/Data_Sphere.Data_Sphere/_git/Fauna.DB.Git
return

#g:: ;Temp
    WinGet nChromeWindows, Count, ahk_class Chrome_WidgetWin_1
    If(nChromeWindows >= 1)
    {
        
        IfWinActive, ahk_class Chrome_WidgetWin_1   
    {
        WinMinimize, ahk_class Chrome_WidgetWin_1   
    }
    else
    {
        WinActivate, ahk_class Chrome_WidgetWin_1   
    }
    } else
    {
        send, ^c
        clipwait
        run, https://www.google.com/search?q=%Clipboard%
    }
return

#h::
    send, ^c
    Sleep, 333
    send, {delete}
    SendInput,sp_helptext '%Clipboard%'
return

#i::
    send, ^c
    clipwait
    send, {delete}
    SendInput,sp_spaceused '%Clipboard%'
return

#j:: ;Jekins
    run, http://speedappdev:1201/view/DB/job/SPEED.TSQL
return

#!j:: ;TeamCity
    run, https://teamcity.icgbuild.nam.nsroot.net/project.html?projectId=icg_cmt_168043
return

#k::
    
return

#+k::
    
return

;#l ;lock windows

;#m ;minimumize winodow

;#n ;new onenote

#o:: ;Tsql.speed
    run, https://tfs.citigroup.net/tfs/Jupiter/Data_Sphere.Data_Sphere/_git/Tsql.speeddb.Git
return 

#p:: ;Udeploy
    run, https://releasedeployment.ti.citigroup.net:8443/#dashboard
    WinWaitActive, IBM UrbanCode Deploy: Log In - Google Chrome ahk_class Chrome_WidgetWin_1
    Sleep, 1333
    SendRaw, `t
    ;Sleep, 333
	;Credential := GetCredential("Me")
    ;SendRaw, %Credential%
return

#q:: ;Lync
   IfWinExist, Skype for Business ahk_class CommunicatorMainWindowClass ahk_exe lync.exe
    {
        IfWinActive, Skype for Business ahk_class CommunicatorMainWindowClass ahk_exe lync.exe
        {
            WinMinimize, Skype for Business ahk_class CommunicatorMainWindowClass ahk_exe lync.exe
        }
        else
        {
            WinActivate, Skype for Business ahk_class CommunicatorMainWindowClass ahk_exe lync.exe
        }
    }
    else{ 
        run, C:\Program Files (x86)\Microsoft Office\Office16\lync.exe
    }
    
return
#r:: ;Remote Desktop Manager

Program := "WindowsForms10.Window.8.app.0.2a125d8_r24_ad1"
Exe := "C:\Users\qz55554\AppData\Local\Programs\Remote Desktop Connection Manager\RDCMan.exe"

BindProgram(Program, Exe)

return

;#s ;snapshot
;https://tfs.citigroup.net/tfs/Jupiter/Data_Sphere.Data_Sphere/_dashboards
#+t:: ;TFS
    IfWinExist, ToMeInActive - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1
    {
        IfWinActive, ToMeInActive - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1
        {
            WinMinimize, ToMeInActive - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1
        }
        else
        {
            WinActivate, ToMeInActive - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1
        }
    }
    else{ 
        run, https://tfs.citigroup.net/tfs/Jupiter/Speed.Git/_workitems`#path=My`+Queries`%2FToMeInActive`&_a=query
    }
return

#t:: ;TFS
    IfWinExist, ToMeInActive2 - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1
    {
        IfWinActive, ToMeInActive2 - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1
        {
            WinMinimize
        }
        else
        {
            WinActivate
        }
    }
    else{ 
        run, https://tfs.citigroup.net/tfs/Oberon/Data_Sphere.Data_Sphere/_workitems`#path=My`+Queries`%2FToMeInActive2`&_a=query
    }
return

;#u ;used by pc

#v:: ;ServiceNow
    run, https://servicemanagement.citigroup.net/
    IfWinExist, Citi Service Management Suite: Sign-On - Google Chrome ahk_class Chrome_WidgetWin_1
    {
        WinWaitActive, Citi Service Management Suite: Sign-On - Google Chrome ahk_class Chrome_WidgetWin_1
        Sleep, 1333
        Credential := GetCredential("Me")
        SendRaw, %Credential%
    }
return


#w:: ;Wiki
    run, https://cedt-confluence.nam.nsroot.net/confluence/display/156762/DataSphere+Release+List+2017
    IfWinExist, Citi Service Management Suite: Sign-On - Google Chrome ahk_class Chrome_WidgetWin_1
    {
        WinWaitActive, Citi Service Management Suite: Sign-On - Google Chrome ahk_class Chrome_WidgetWin_1
        Sleep, 1333
        Credential := GetCredential("Me")
        SendRaw, %Credential%
    }
return

#x::
    run, explorer.exe C:\Users\qz55554\Links
    WinWaitActive, Links ahk_class CabinetWClass
    sleep, 1000
    send, ^f
Return

#z:: ;appwiz.cpl
   run, appwiz.cpl
return


#1::
    run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe
    WinWaitActive, MINGW64:/c/Users/qz55554/Documents/MyScripts, , 2
    WinActivate, MINGW64:/c/Users/qz55554/Documents/MyScripts
    SendInput, cd ~/Source/Repo/Tsql.speeddb.Git/Tsql.speeddb/`n
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
    SendInput, cd ~/Source/Repo/Fauna.DB.2014.Git/Fauna.DB2014`n
    SendInput, git status`n
    SendInput, git pull`n
    SendInput, ls`n
return
#4::
IfWinNotExist Speed_DataAnalysis - Microsoft SQL Server Management Studio
{
    run, "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\Ssms.exe" "C:\Users\qz55554\Documents\SQL Server Management Studio\Speed_DataAnalysis.ssmssln"
}else
{
    IfWinActive, Speed_DataAnalysis - Microsoft SQL Server Management Studio
    {
        WinMinimize, Speed_DataAnalysis - Microsoft SQL Server Management Studio
    }
    else
    {
        WinActivate, Speed_DataAnalysis - Microsoft SQL Server Management Studio
    }
}
return

#5::
IfWinNotExist ahk_class SWT_Window0 ahk_exe javaw.exe
{
    run, "C:\Users\qz55554\AppData\Local\Programs\Eclipse\eclipse\eclipse.exe"
}else
{
    IfWinActive, ahk_class SWT_Window0 ahk_exe javaw.exe
    {
        WinMinimize, ahk_class SWT_Window0 ahk_exe javaw.exe
    }
    else
    {
        WinActivate, ahk_class SWT_Window0 ahk_exe javaw.exe
    }
}
return


;;;;;;;;;;;;;;;;;;;   Code check-in
#Numpad0::
    ;run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe --InGit
    BranchNo := Clipboard
    SendInput, git add -A`n
    sleep, 2000
    SendInput, {Raw}git commit -m "U #%BranchNo% autocommit"`n
    sleep, 2000
    SendInput, git push`n
return

#!Numpad0::
    ;run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe --InGit
    BranchNo := Clipboard
    SendInput, git add -A`n
    sleep, 2000
    SendInput, {Raw}git commit -m "U #%BranchNo% autocommit"`n
    sleep, 2000
    SendInput, git push --set-upstream origin UserStory_%BranchNo%`n
return



;;;;;;;;;;;;;;;;;;;   PULL REQUEST  -  Chorme Window Left
#Numpad1:: ;TSQL pull request
    send, ^c
    ClipWait
    BranchNo := Clipboard
    TargetUrl := "https://tfs.citigroup.net/tfs/Oberon/Data_Sphere.Data_Sphere/_git/Tsql.speeddb.Git/pullrequests?_a=createnew&sourceRef=" BranchNo "&targetRef=develop"
    Run, %TargetUrl%
    Sleep, 5000
    WinWaitActive, Pull Requests - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    IfWinExist, Pull Requests - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        MouseClick, left, 400, 550
        SendInput, Jw70294;xz58247;sr05896;yy68555;mp71077;jg61298
    }

return

#!Numpad1:: ;SSIS
    send, ^c
    ClipWait
    BranchNo := Clipboard
    TargetUrl := "https://tfs.citigroup.net/tfs/Oberon/Data_Sphere.Data_Sphere/_git/Fauna.DB.2014.Git/pullrequests?_a=createnew&sourceRef=" BranchNo "&targetRef=develop"
    Run, %TargetUrl%
    Sleep, 2000
    WinWaitActive, Pull Requests - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    IfWinExist, Pull Requests - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        MouseClick, left, 400, 550
        SendInput, Jw70294;xz58247;sr05896;yy68555;mp71077;jg61298
    }
    
return

;;;;;;;;;;;;;;;;;;;   Jekins
#Numpad2:: ;TSQL
    run, http://speedappdev:1201/view/DB/job/SPEED.TSQL/build?delay=0sec#skip2content
    WinWaitActive, Jenkins - Google Chrome ahk_class Chrome_WidgetWin_1
	Credential := GetCredential("Jks")
    SendRaw, %Credential%    
return

#!Numpad2:: ;SSIS
    run, http://speedappdev:1201/view/DB/job/SPEED.SSIS/build?delay=0sec#skip2content
    WinWaitActive, Jenkins - Google Chrome ahk_class Chrome_WidgetWin_1
	Credential := GetCredential("Jks")
    SendRaw, %Credential%    
return

;;;;;;;;;;;;;;;;;;;   UDeploy
#Numpad3::
    run, https://releasedeployment.ti.citigroup.net:8443/#dashboard
    Sleep, 2000
    IfWinExist, IBM UrbanCode Deploy: Log In - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        SendRaw,`t
        Credential := GetCredential("Me")
        SendRaw, %Credential%   
    }
    
	WinWaitActive, IBM UrbanCode Deploy: Dashboard - Google Chrome ahk_class Chrome_WidgetWin_1
	IfWinExist, IBM UrbanCode Deploy: Dashboard - Google Chrome ahk_class Chrome_WidgetWin_1
    {
		WinActivate, IBM UrbanCode Deploy: Dashboard - Google Chrome ahk_class Chrome_WidgetWin_1
		MouseClick, left, 300, 165
		Sleep, 1333
		MouseClick, left, 355, 440 
		Sleep, 1333
		MouseClick, left, 60, 590 
		Sleep, 1333
        IF (gMonitor="Dell"){
            MouseClick, left, 909, 500 
            Sleep, 1000
            MouseClick, left, 1186, 528
            Sleep, 1000
            ; TSQL
            MouseClickDrag, left, 1188,578,1188,627
            MouseClick, left,1000,763

            Sleep, 1000
            MouseClick,left, 1022,649
            Sleep, 1000
            MouseClick,left, 730,508
            Sleep, 1000
            MouseClick,left, 727,536
            ; Confirm version
            Sleep, 2000
            MouseClick,left, 1297,714
        }
        else{
        ;<TBD>
        }
	}
return

#!Numpad3::
    run, https://releasedeployment.ti.citigroup.net:8443/#dashboard
    Sleep, 2000
    IfWinExist, IBM UrbanCode Deploy: Log In - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        SendRaw,`t
        Credential := GetCredential("Me")
        SendRaw, %Credential%   
    }
	WinWaitActive, IBM UrbanCode Deploy: Dashboard - Google Chrome ahk_class Chrome_WidgetWin_1
	IfWinExist, IBM UrbanCode Deploy: Dashboard - Google Chrome ahk_class Chrome_WidgetWin_1
    {
        WinActivate, IBM UrbanCode Deploy: Dashboard - Google Chrome ahk_class Chrome_WidgetWin_1
		MouseClick, left, 300, 165
		Sleep, 1000
		MouseClick, left, 355, 440 
		Sleep, 1000
		MouseClick, left, 60, 590 
		Sleep, 1000
        IF (gMonitor="Dell"){
            MouseClick, left, 909, 541 
            Sleep, 1000
            MouseClick, left, 1190, 527
            Sleep, 1000
            ; SSIS
            MouseClick, left,1029,745

            Sleep, 1000
            MouseClick,left, 1023,650
            Sleep, 1000
            MouseClick,left, 720,505
            MouseClick,left, 720,545
            ; Confirm version
            Sleep, 2000
            MouseClick,left, 1290,712
        }
        else{
        ;<TBD>
        }
	}
return




#Numpad9::
    
 Sleep,333
    send, ^c
    ClipWait
    CourseKey := Clipboard
    TargetUrl := "https://training.citigroup.net/SumTotal/learner/search?searchText=" CourseKey 
    Run, %TargetUrl%
    Sleep, 2000
    IfWinExist, Single Sign-On - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        WinWaitActive, Single Sign-On - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
        Sleep, 333
        SendRaw, `t`t
        Credential := GetCredential("Me")
        SendRaw, %Credential% 
        Sleep, 333
        SendRaw, `t`r
    }   
return

/*
------------------------------------------------------------------
    Window Switch Section
------------------------------------------------------------------
*/

#F1::
     IfWinActive, Microsoft Excel - QueryAnalysis.xlsx ahk_class XLMAIN
    {
        WinMinimize, Microsoft Excel - QueryAnalysis.xlsx ahk_class XLMAIN
    }
    else
    {
        WinActivate, Microsoft Excel - QueryAnalysis.xlsx ahk_class XLMAIN
    }
return

#F2::
    IfWinNotExist, ahk_class Notepad++ ahk_exe notepad++.exe
    {
        run, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Applications\Notepad++.lnk" 
    }
    else{
        IfWinActive, ahk_class Notepad++ ahk_exe notepad++.exe
        {
            WinMinimize,  ahk_class Notepad++ ahk_exe notepad++.exe
        }
        else
        {
            WinActivate,  ahk_class Notepad++ ahk_exe notepad++.exe
        }
    }
return

#F3::
    IfWinNotExist, ahk_class XLMAIN ahk_exe EXCEL.EXE
    {
        run, "C:\Program Files (x86)\Microsoft Office\Office16\EXCEL.EXE" 
        WinActivate, ahk_class XLMAIN ahk_exe EXCEL.EXE
    }
    else{
        IfWinActive, ahk_class XLMAIN ahk_exe EXCEL.EXE
        {
            WinMinimize,  ahk_class XLMAIN ahk_exe EXCEL.EXE
        }
        else
        {
            WinActivate,  ahk_class XLMAIN ahk_exe EXCEL.EXE
        }
    }
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













^#e::
    Credential := GetCredential("eMBS")
    SendRaw, %Credential%  
Return






^#a::
    Credential := GetCredential("Me")
    SendRaw, %Credential%  
Return


^#b::
    Credential := GetCredential("Sys")
    SendRaw, %Credential%  
Return

^#d::
    Credential := GetCredential("Spark")
    SendRaw, %Credential%  
Return


^#s::
    Credential := GetCredential("Sys","u")
    SendRaw %Credential%
Return

^#w::
    Credential := GetCredential("Sys","p")
    SendRaw %Credential%
Return

^#u::
    Credential := GetCredential("Me","u")
    SendRaw %Credential%
RETURN

^#p::
    Credential := GetCredential("Me","p")
    SendRaw %Credential%
Return


^#j::
    Credential := GetCredential("Jks")
    SendRaw %Credential%
Return