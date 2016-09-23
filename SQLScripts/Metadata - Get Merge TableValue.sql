
DECLARE @SourceSchema NVARCHAR(50) = 'dbo'
DECLARE @TargetSchema NVARCHAR(50) = 'dbo'
DECLARE @TableName NVARCHAR(50) = 'BIMLDestination'
DECLARE @UK1 NVARCHAR(50) = 'Name'
DECLARE @UK2 NVARCHAR(50) = ''
DECLARE @UK3 NVARCHAR(50) = ''
DECLARE @UK4 NVARCHAR(50) = ''
--
DECLARE @Sql NVARCHAR(MAX) = ''
DECLARE @Declare NVARCHAR(MAX) = ''
DECLARE @PreSql NVARCHAR(MAX) = ''
DECLARE @Matched NVARCHAR(MAX) = ''
DECLARE @MidSql NVARCHAR(MAX) = ''
DECLARE @NotMatched_T NVARCHAR(MAX) = ''
DECLARE @MidSql2 NVARCHAR(MAX) = ''
DECLARE @NotMatched_S NVARCHAR(MAX) = ''
DECLARE @PostSql NVARCHAR(MAX) = ''

DECLARE @PK NVARCHAR(50)
SELECT  @PK = CCU.COLUMN_NAME
FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
        INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS CCU ON CCU.CONSTRAINT_CATALOG = TC.CONSTRAINT_CATALOG
                                                              AND CCU.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
                                                              AND CCU.CONSTRAINT_SCHEMA = TC.CONSTRAINT_SCHEMA
                                                              AND CCU.TABLE_CATALOG = TC.TABLE_CATALOG
                                                              AND CCU.TABLE_NAME = TC.TABLE_NAME
                                                              AND CCU.TABLE_SCHEMA = TC.TABLE_SCHEMA
WHERE   CONSTRAINT_TYPE = 'PRIMARY KEY'
        AND TC.TABLE_SCHEMA = @TargetSchema
        AND TC.TABLE_NAME = @TableName
	

SELECT  @Declare = 'DECLARE @JobID BIGINT = ?' + CHAR(10)
        + 'DECLARE @Date DATETIME2 = GETUTCDATE()' + CHAR(10)
        --+ 'DECLARE @DataSourceID BIGINT = ?' + CHAR(10)
--PRINT @Declare
SELECT  @PreSql = 'MERGE ' + @TargetSchema + '.' + @TableName + ' AS TARGET'
        + CHAR(10) + 'USING ' + @SourceSchema + '.' + @TableName
        + ' AS SOURCE ' + 'ON SOURCE.' + @UK1 + ' = TARGET.' + @UK1 + CHAR(10)
        + CASE WHEN @UK2 = ''
                    OR @UK2 IS NULL THEN ''
               ELSE ' AND ' + ' SOURCE.' + @UK2 + ' = TARGET.' + @UK2
                    + CHAR(10)
          END + CASE WHEN @UK3 = ''
                          OR @UK3 IS NULL THEN ''
                     ELSE ' AND ' + ' SOURCE.' + @UK3 + ' = TARGET.' + @UK3
                          + CHAR(10)
                END + CASE WHEN @UK4 = ''
                                OR @UK4 IS NULL THEN ''
                           ELSE ' AND ' + ' SOURCE.' + @UK4 + ' = TARGET.'
                                + @UK4 + CHAR(10)
                      END + 'WHEN MATCHED THEN' + CHAR(10) + 'UPDATE SET ' 
--PRINT @PreSql

SELECT  @Matched += ',TARGET.' + COLUMN_NAME + ' = SOURCE.' + COLUMN_NAME
        + CHAR(10)
FROM    INFORMATION_SCHEMA.COLUMNS
WHERE   TABLE_SCHEMA = @TargetSchema
        AND TABLE_NAME = @TableName
        AND COLUMN_NAME NOT IN ( 'Rowversion', 'ETLInsertedJobID',
         --                        'ETLUpdatedJobID', 
                                 'ETLInsertedDateTime',
         --                        'ETLUpdatedDateTime',
         --                        'LateArrivalRecordProcessFlag',
                                 'DataSourceId', @PK, @UK1, @UK2, @UK3, @UK4 )
--PRINT @Matched

SELECT  @MidSql = 'WHEN NOT MATCHED' + CHAR(10) + 'THEN INSERT (' 
--PRINT @MidSql

SELECT  @NotMatched_T += ',' + C.COLUMN_NAME + CHAR(10) ,
        @NotMatched_S += ','
        --+ CASE WHEN C.COLUMN_NAME IN ( 'ETLInsertedJobID', 'ETLUpdatedJobID' )
        --       THEN '@JobId'
        --       WHEN C.COLUMN_NAME IN ( 'ETLInsertedDateTime',
        --                               'ETLUpdatedDateTime' ) THEN '@Date'
        --       WHEN C.COLUMN_NAME = 'DataSourceId' THEN '@DataSourceID'
        --       ELSE 'SOURCE.'+C.COLUMN_NAME END
        + 'SOURCE.' + C.COLUMN_NAME + CHAR(10)
FROM    INFORMATION_SCHEMA.COLUMNS AS C
        INNER JOIN ( SELECT CCU.COLUMN_NAME
                     FROM   INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
                            INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
                            AS CCU ON CCU.CONSTRAINT_CATALOG = TC.CONSTRAINT_CATALOG
                                      AND CCU.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
                                      AND CCU.CONSTRAINT_SCHEMA = TC.CONSTRAINT_SCHEMA
                                      AND CCU.TABLE_CATALOG = TC.TABLE_CATALOG
                                      AND CCU.TABLE_NAME = TC.TABLE_NAME
                                      AND CCU.TABLE_SCHEMA = TC.TABLE_SCHEMA
                     WHERE  CONSTRAINT_TYPE = 'PRIMARY KEY'
                            AND TC.TABLE_SCHEMA = @TargetSchema
                            AND TC.TABLE_NAME = @TableName
                   ) AS PK ON PK.COLUMN_NAME != C.COLUMN_NAME
WHERE   C.TABLE_SCHEMA = @TargetSchema
        AND C.TABLE_NAME = @TableName
        AND C.COLUMN_NAME != 'Rowversion'
		

SELECT  @MidSql2 = ')' + CHAR(10) + 'VALUES ('

--PRINT @NotMatched_T
--PRINT @MidSql2
--PRINT @NotMatched_S

SELECT  @PostSql = ');'

SELECT  @Sql = @Declare + CHAR(10) + @PreSql + STUFF(@Matched, 1, 1, '')
        + CHAR(10) + @MidSql + STUFF(@NotMatched_T, 1, 1, '') + @MidSql2
        + STUFF(@NotMatched_S, 1, 1, '') + @PostSql

PRINT @Sql