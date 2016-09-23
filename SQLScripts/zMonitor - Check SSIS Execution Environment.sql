--Check Execution Environment
DECLARE @EnvironmentName NVARCHAR(50) = '%Chat%'

SELECT  environments.environment_id ,
        environment_name ,
        environments.description ,
        variable_id ,
        name ,
        environment_variables.description ,
        type ,
        value
FROM    SSISDB.internal.environments
        INNER JOIN SSISDB.internal.environment_variables ON environment_variables.environment_id = environments.environment_id
WHERE   environment_name LIKE @EnvironmentName