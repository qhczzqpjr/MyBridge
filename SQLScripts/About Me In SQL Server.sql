
--My Permission
SELECT * FROM fn_my_permissions(NULL, 'SERVER');
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');

 select 
    cpu_count
,    hyperthread_ratio
,    physical_memory_in_bytes / 1048576 as 'mem_MB'
,    virtual_memory_in_bytes / 1048576 as 'virtual_mem_MB'
,    max_workers_count
,    os_error_mode
,    os_priority_class
from 
    sys.dm_os_sys_info


SELECT 
	windows_release
	,windows_service_pack_level
	,windows_sku
	,os_language_version
FROM sys.dm_os_windows_info;


--Server Property
SELECT 'BuildClrVersion' ColumnName, SERVERPROPERTY('BuildClrVersion') ColumnValue
UNION ALL
SELECT 'Collation', SERVERPROPERTY('Collation')
UNION ALL
SELECT 'CollationID', SERVERPROPERTY('CollationID')
UNION ALL
SELECT 'ComparisonStyle', SERVERPROPERTY('ComparisonStyle')
UNION ALL
SELECT 'ComputerNamePhysicalNetBIOS', SERVERPROPERTY('ComputerNamePhysicalNetBIOS')
UNION ALL
SELECT 'Edition', SERVERPROPERTY('Edition')
UNION ALL
SELECT 'EditionID', SERVERPROPERTY('EditionID')
UNION ALL
SELECT 'EngineEdition', SERVERPROPERTY('EngineEdition')
UNION ALL
SELECT 'InstanceName', SERVERPROPERTY('InstanceName')
UNION ALL
SELECT 'IsClustered', SERVERPROPERTY('IsClustered')
UNION ALL
SELECT 'IsFullTextInstalled', SERVERPROPERTY('IsFullTextInstalled')
UNION ALL
SELECT 'IsIntegratedSecurityOnly', SERVERPROPERTY('IsIntegratedSecurityOnly')
UNION ALL
SELECT 'IsSingleUser', SERVERPROPERTY('IsSingleUser')
UNION ALL
SELECT 'LCID', SERVERPROPERTY('LCID')
UNION ALL
SELECT 'LicenseType', SERVERPROPERTY('LicenseType')
UNION ALL
SELECT 'MachineName', SERVERPROPERTY('MachineName')
UNION ALL
SELECT 'NumLicenses', SERVERPROPERTY('NumLicenses')
UNION ALL
SELECT 'ProcessID', SERVERPROPERTY('ProcessID')
UNION ALL
SELECT 'ProductVersion', SERVERPROPERTY('ProductVersion')
UNION ALL
SELECT 'ProductLevel', SERVERPROPERTY('ProductLevel')
UNION ALL
SELECT 'ResourceLastUpdateDateTime', SERVERPROPERTY('ResourceLastUpdateDateTime')
UNION ALL
SELECT 'ResourceVersion', SERVERPROPERTY('ResourceVersion')
UNION ALL
SELECT 'ServerName', SERVERPROPERTY('ServerName')
UNION ALL
SELECT 'SqlCharSet', SERVERPROPERTY('SqlCharSet')
UNION ALL
SELECT 'SqlCharSetName', SERVERPROPERTY('SqlCharSetName')
UNION ALL
SELECT 'SqlSortOrder', SERVERPROPERTY('SqlSortOrder')
UNION ALL
SELECT 'SqlSortOrderName', SERVERPROPERTY('SqlSortOrderName')
