DECLARE @project_name varchar(200) = '%incident%'

--Get package running status
SELECT TOP 3
    operation_id
    ,object_name
    ,start_time
    ,end_time
    ,Case Status
        When 1 then N'created'
        When 2 then N'Running'
        When 3 then N'Cancelled'
        When 4 then N'Failed'
        When 5 then N'HangUP'
        When 6 then N'Abort'
        When 7 then N'Success'
        When 8 then N'Stopped'
        When 9 then N'Finished'
        Else '' 
    END AS status
    ,DATEDIFF(minute,start_time,end_time) t
FROM SSISDB.internal.operations o (nolock)
WHERE object_name LIKE @project_name
ORDER BY operation_id DESC

DECLARE @execution_id int

SELECT * FROM SSISDB.[internal].[executions] where execution_id = @execution_id
SELECT * FROM SSISDB.[internal].[execution_parameter_values] where execution_id = @execution_id

--Get package running details
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
        WHEN 40 THEN N'Control Flow tasks'
        WHEN 30 THEN N'Package-level objects'
        WHEN 50 THEN N'Control Flow containers'
        WHEN 60 THEN N'Data Flow task' 
        ELSE N' T-SQL '
    END AS type  
	,Message_time
	,TimeEcilpse = DateDiff(second,(SELECT MIN(Message_time) FROM SSISDB.internal.operation_messages where operation_id= a.operation_id),Message_time) /3600.0
FROM SSISDB.internal.operation_messages a (nolock)
WHERE operation_id = @execution_id