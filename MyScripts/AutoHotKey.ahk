;^ = Ctril
;+ = Shift
;! = Alt
;# Windows Key
#SingleInstance force
#Include functions.ahk
#Include HBASE.ahk
;https://tfs.citigroup.net/tfs
;~ Comment/UnComment Code Out - ^Q

;Global Variables
gMonitor:= "Dell"

;Quick TypeIn
::/e::explorer.exe .
::/pr::Jw70294;jg61298;xz58247
::/st::select * from
::/stc::select Count(1) from
::/st10::select top 10 * from
::/sit::SELECT * FROM INFORMATION_SCHEMA.TABLES
::/stit::
     SendRaw, select * from information_schema.tables where table_schema + '.'+ table_name = ''
return
::/stic::
    SendRaw, select * from information_schema.columns where table_schema + '.' + table_name = '' and column_name like '`%`%'
return

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
::/gpn::git push --set-upstream origin feature/
::/gps::git push
::/gcu::git checkout feature/
::/gcun::git checkout -b feature/
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
::/pbr::pbrun gsmspark
::/pbr1::pbrun gsmspark -dap
::/py::C:/Users/qz55554/AppData/Local/Continuum/anaconda3/python.exe
::/httpserver::C:\Users\qz55554\AppData\Local\Continuum\anaconda3\python.exe -m http.server 8000
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
    TargetUrl := "https://tiasysap007gtp.nam.nsroot.net:8443/wcc/login/applicationLogin.faces"
    Run, %TargetUrl%
    Sleep, 2000
    IfWinExist, Login Page - CA Workload Control Center - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    {
        WinWaitActive, Login Page - CA Workload Control Center - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
        Sleep, 333
        Credential := GetCredential("Me")
        SendRaw, %Credential% 
    }
    Sleep, 3000
    MouseClick,left,800,170
    Sleep, 2000
    MouseClick,left,600,275
    Sleep, 1000
    MouseClick,left,400,470
    Sleep, 2000
    MouseClick,left,1050,270
    SendInput, %AutosysJobName%`r
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

;#f::

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


#j:: ;TeamCity - SQL
    run, https://teamcity.icgbuild.nam.nsroot.net/viewType.html?buildTypeId=icg_cmt_168043_ReleaseBuild_DataSpehreTsql
return

#!j:: ;TeamCity - SSIS
    run, https://teamcity.icgbuild.nam.nsroot.net/viewType.html?buildTypeId=icg_cmt_168043_ReleaseBuild_DataSphereSsis
return


#k::
    
return

#+k::
    
return

;#l ;lock windows

;#m ;minimumize winodow

;#n ;new onenote

;#o

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
    BindProgram("Skype for Business ahk_class CommunicatorMainWindowClass ahk_exe lync.exe", "C:\Program Files (x86)\Microsoft Office\Office16\lync.exe")
return
#r:: ;Remote Desktop Manager
    BindProgram("WindowsForms10.Window.8.app.0.2a125d8_r24_ad1", "C:\Users\qz55554\AppData\Local\Programs\Remote Desktop Connection Manager\RDCMan.exe")
return

;#s ;snapshot

;TFS
#+t:: 
    BindProgram("ToMeInActive - Microsoft Team Foundation Server - Google Chrome ahk_class Chrome_WidgetWin_1","https://tfs.citigroup.net/tfs/Jupiter/Speed.Git/_workitems`#path=My`+Queries`%2FToMeInActive`&_a=query")
return

;JIRA
#t:: 
    BindProgram("[My Open Issues] Issue Navigator - CEDT ICG JIRA DC - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    ,"https://cedt-icg-jira.nam.nsroot.net/jira/issues/?filter=-1")
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
    run, https://cedt-confluence.nam.nsroot.net/confluence/display/156762/DataSphere+Release+List+2018
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

#0::
  run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe
    WinWaitActive, MINGW64:/c/Users/qz55554/Documents/MyScripts, , 2
    WinActivate, MINGW64:/c/Users/qz55554/Documents/MyScripts
    SendInput, cd /i/BKP/github/MyBridge`n
    SendInput, git status`n
    SendInput, ls`n
return


;SMSS
#4::
    BindProgram("Speed_DataAnalysis - Microsoft SQL Server Management Studio","""C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\Ssms.exe""" """C:\Users\qz55554\Documents\SQL Server Management Studio\Speed_DataAnalysis.ssmssln""")
return

;Eclipse
#5::
    BindProgram("ahk_class SWT_Window0 ahk_exe javaw.exe","C:\Users\qz55554\AppData\Local\Programs\Eclipse\eclipse\eclipse.exe")
return 

;;;;;;;;;;;;;;;;;;;   Code check-in
#Numpad0::
    ;run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe --InGit
    BranchNo := Clipboard
    SendInput, git add -A`n
    sleep, 2000
    SendInput, {Raw}git commit -m "%BranchNo% autocommit"`n
    sleep, 2000
    SendInput, git push`n
return

#!Numpad0::
    ;run, C:\Users\qz55554\AppData\Local\Programs\Git\git-bash.exe --InGit
    BranchNo := Clipboard
    SendInput, git add -A`n
    sleep, 2000
    SendInput, {Raw}git commit -m "%BranchNo% autocommit"`n
    sleep, 2000
    SendInput, git push --set-upstream origin %BranchNo%`n
return



;;;;;;;;;;;;;;;;;;;   Code Review
#Numpad1::
 
return

#!Numpad1::
return

;;;;;;;;;;;;;;;;;;;   Code Build
#Numpad2::  
return

#!Numpad2:: 
return

;;;;;;;;;;;;;;;;;;;   Code Deployment
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



/*
------------------------------------------------------------------
    Window Switch Section
------------------------------------------------------------------
*/

;~ #F1::

;~ return

#F2::
    BindProgram("ahk_class Notepad++ ahk_exe notepad++.exe","C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Applications\Notepad++.lnk" )
return

#F3::
    BindProgram("ahk_class XLMAIN ahk_exe EXCEL.EXE","C:\Program Files (x86)\Microsoft Office\Office16\EXCEL.EXE" )
return


^#e::
    Credential := GetCredential("eMBS")
    SendRaw, %Credential%  
Return


^#b::
    Credential := GetCredential("Sys")
    SendRaw, %Credential%  
Return

;~ ^#d::
    ;~ Credential := GetCredential("Spark")
    ;~ SendRaw, %Credential%  
;~ Return


^#s::
    Credential := GetCredential("Sys","u")
    SendRaw %Credential%
Return

^#w::
    Credential := GetCredential("Sys","p")
    SendRaw %Credential%
Return


^#j::
    Credential := GetCredential("Jks")
    SendRaw %Credential%
Return

