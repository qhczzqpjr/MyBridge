#SingleInstance, Force



JobList = 
(
156762_S2_Neo_IntexYieldTable
156762_LoadNeoFAS157
156762_LoadNeoFAS157_BD1
156762_LoadNeoPriceVerification
156762_NeoBVALResponse
156762_NeoBVALResponse
156762_NEO_Airs_Loader
156762_GENESIS_DataFeed
156762_LoadIntexSecurityID
156762_OSCAR_Copy_SPEED_Tables
156762_OSCAR_Load_Support_Tables
156762_OSCAR_LoadTables
156762_OSCAR_OptimaSMCDataFeed
156762_OSCAR_DQC_Run_Data_Quality_Checks
156762_OSCAR_PreProcessing_Weekend
156762_OSCAR_LoadTables_Weekend
156762_STAR2SPEEDInterface
156762_MQABaselJob_FileTrigger_RunModel
156762_MQABaselJob_ClearFileTriggerFiles
156762_MQABaselJob_RunModel
156762_MQABaselJob_FileTrigger_Handle_ModelResults_UserReview
156762_MQABaselJob_Handle_ModelResults_UserReview 
)
Gui, Add, Edit, vMyVar ReadOnly w500 r30,%JobList% 

 
Gui, Show,, Protal
return  ; End of auto-execute section. The script is idle until the user does something.
GuiClose:
ButtonOK:

ExitApp
#Include AutoHotKey.ahk
/*
; GUI Layout
Gui, Font, cBlack

Gui, Add, Text, x10 y10, Press the Button
Gui, Add, Button, x30 y30 w200 h30 gAutosys, Go to Autosys

Gui, +AlwaysOnTop
Gui, Color, C6C6C6
Gui,Show,x800 y50 w500 h500, Portal
return


; Lables
------------
GuiClose:
	ExitApp
return


Autosys:
    AutosysJobName := Clipboard
    TargetUrl := "https://tiawccap001swq.nam.nsroot.net:10157/QuickView/pages/main.jsf?serverName=PA6&displayMode=inFrame&jobName=" AutosysJobName "&conversationContext=1"
    Run, %TargetUrl%
    WinWaitActive, Login - CA Workload Control Center - Google Chrome ahk_class Chrome_WidgetWin_1
    Sleep, 333
	Credential := GetCredential()
    SendRaw, %Credential%
return

 */