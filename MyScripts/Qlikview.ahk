#SingleInstance Force
#Include functions.ahk
;Update config
^F1::
	run, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Applications\Notepad++.lnk" "C:\Users\qz55554\Desktop\Eagle\Eagle\EAGLE\20_QV_INCLUDE\GSM-Eagle-Config.cfg"
return

 
;Load staging
^F2::	
	BindProgram("QlikView x64 - [Eagle_DQ_QVDG*] ahk_exe Qv.exe","""C:\Program Files\QlikView\Qv.exe"" ""C:\Users\qz55554\Desktop\Eagle\Eagle\EAGLE\40_GLOBAL_QVDG\GSM\GSM_EAGLE_QVDG.qvw""")
return

;Load data model
^F3::
    BindProgram("QlikView x64 - [Eagle_Data_Quality_DM*] ahk_exe Qv.exe","""C:\Program Files\QlikView\Qv.exe"" ""C:\Users\qz55554\Desktop\Eagle\Eagle\EAGLE\60_DASHBOARDS\GSMDQ\40_DATA_MODEL\Eagle_GSM_Data_Quality_DM.qvw""")
return

; View
^F4::
    BindProgram("QlikView x64 - [Eagle - GSM Data Quality Dashboard*] ahk_exe Qv.exe","""C:\Program Files\QlikView\Qv.exe"" ""C:\Users\qz55554\Desktop\Eagle\Eagle\EAGLE\60_DASHBOARDS\GSMDQ\50_APPLICATION\Eagle GSM Data Quality Dashboard.qvw""")
return
^F5::
	run, explorer.exe "C:\Users\qz55554\Desktop\Eagle\Eagle\EAGLE\50_GLOBAL_QVD\GSM"
return

::/ck0::https://qa.citivelocity.com/eagleRest/service/executeEagleQuery?queryName=GSMReportMonitoring&pageSize=100&pageNum=1
::/ck1::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMReportDatesLoaded&pageSize=1000&pageNum=1&afterDate=2017-03-19&afterTime=00:00:00
::/ck2::http://eagle_qat:28081/eagleRest/service/insertReportTrigger?message={{}"reportUniqueName":"GSM_DQ_POC","reportDateAsNumber":20180515{}}
::/ckc::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMClientConfig&pageSize=2000&pageNum=1
::/ckr::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMReportConfig&pageSize=10000&pageNum=1
::/ckcc::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMCheckConfig&pageSize=1000&pageNum=1
::/cks::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMCheckResultSummary&pageSize=100000&pageNum=1&ReportDate=20180513
::/ckd::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMCheckResultBreakdown&pageSize=100000&pageNum=1&ReportDate=20180513
::/cki::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMEagleIssues&pageSize=1000&pageNum=1
::/ckk::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMEagleJIRADetails&pageSize=1000&pageNum=1
::/ckt::http://eagle_qat:28081/eagleRest/service/executeEagleQuery?queryName=GSMPredefinedQueryTemplates&pageSize=1000&pageNum=1
