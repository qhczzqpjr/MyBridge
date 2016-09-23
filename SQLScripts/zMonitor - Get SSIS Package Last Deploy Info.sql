DECLARE @ProjectName NVARCHAR(50) = '%Incident%'

SELECT  DISTINCT
        f.name FolderName ,
        proj.name AS ProjectName ,
        pkg.name AS Package ,
        proj.last_deployed_time
FROM    SSISDB.[internal].[projects] AS proj
        JOIN SSISDB.[internal].folders AS f ON f.folder_id = proj.folder_id
        JOIN SSISDB.internal.packages pkg ON pkg.project_id = proj.project_id
WHERE   proj.name LIKE  @ProjectName
        --AND pkg.name = @package_name
