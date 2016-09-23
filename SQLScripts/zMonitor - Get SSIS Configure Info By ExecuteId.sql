--Get Execution package configuration from Execution_id
DECLARE @Execution_id int = 1000

SELECT  M.parameter_name ,
        parameter_value ,
        executed_as_name ,
        folder_name ,
        project_name ,
        package_name ,
        environment_name ,
        M.parameter_data_type
FROM    SSISDB.internal.executions L ( NOLOCK )
        INNER JOIN SSISDB.internal.execution_parameter_values M ( NOLOCK ) ON L.execution_id = M.execution_id
WHERE   L.execution_id = @Execution_id