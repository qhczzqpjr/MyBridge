SELECT 
    CASE message_type 
        When -1 then N'Unknown'
        When 120 then N'Error'
        When 110 then N'Warning'
        When 70 then N'Information'
        When 10 then N'Pre-validate'
        When 20 then N'Post-validate'
        When 30 then N'Pre-execute'
        When 40 then N'Post-execute'
        When 60 then N'Progress'
        When 50 then N'StatusChange'
        When 100 then N'QueryCancel'
        When 130 then N'TaskFailed'
        When 90 then N'Diagnostic'
        When 200 then N'Custom'
        When 140 then N'DiagnosticEx'
        When 400 then N'NonDiagnostic'
        When 80 then N'VariableValueChanged'
    End AS Information
    ,message
    ,CASE message_source_type 
        WHEN 40 THEN N'控制流任务'
        WHEN 30 THEN N'包级别对象'
        WHEN 50 THEN N'控制流容器'
        WHEN 60 THEN N'数据流任务' 
        ELSE N' T-SQL '
    END AS type  
	,Message_time
	,TimeEcilpse = DateDiff(second,(SELECT MIN(Message_time) FROM SSISDB.internal.operation_messages where operation_id= a.operation_id),Message_time) /3600.0
FROM SSISDB.internal.operation_messages a (nolock)
WHERE operation_id = @Execution_id
