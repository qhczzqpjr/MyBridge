/************************************************************************************************************
    Owner: Thomas Zhu
    Date: 2015-09-11
    Description:
        This script is used to generate the foreign key constraints based on the columnName between tables
    Notes:
        1. Only works for objects in current database 
    Next Version:
        1.Dynamic map support by implementing rule, Ex: (Sales.StartDateId | Sales.EndDateId) ->DateTime.DateId
*************************************************************************************************************/
DECLARE @DB NVARCHAR(50) = N'DataWarehouse'
DECLARE @SCHEMA NVARCHAR(50) = N'Fact'
DECLARE @TABLE NVARCHAR(50) = N'Incident';
WITH    PK
          AS ( SELECT  DISTINCT
                        KCU.TABLE_SCHEMA ,
                        KCU.TABLE_NAME ,
                        COLUMN_NAME
               FROM     INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
                        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU ON KCU.CONSTRAINT_CATALOG = TC.CONSTRAINT_CATALOG
                                                              AND KCU.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
                                                              AND KCU.CONSTRAINT_SCHEMA = TC.CONSTRAINT_SCHEMA
                                                              AND KCU.TABLE_CATALOG = TC.TABLE_CATALOG
                                                              AND KCU.TABLE_NAME = TC.TABLE_NAME
                                                              AND KCU.TABLE_SCHEMA = TC.TABLE_SCHEMA
               WHERE    CONSTRAINT_TYPE = 'PRIMARY KEY'
                        AND KCU.TABLE_SCHEMA IN ( 'FACT', 'DIM' )
             )
    SELECT  'ALTER TABLE ' + C.TABLE_CATALOG + '.' + C.TABLE_SCHEMA + '.'
            + C.TABLE_NAME + ' ADD CONSTRAINT ' + 'FK_' + C.TABLE_NAME + '_'
            + C.COLUMN_NAME + ' FOREIGN KEY ( ' + C.COLUMN_NAME
            + ') REFERENCES ' + PK.TABLE_SCHEMA + '.' + PK.TABLE_NAME + '('
            + PK.COLUMN_NAME + ')'
    FROM    INFORMATION_SCHEMA.COLUMNS AS C
            INNER JOIN PK ON C.COLUMN_NAME = PK.COLUMN_NAME
                             AND ( C.TABLE_SCHEMA != PK.TABLE_SCHEMA
                                   AND PK.TABLE_NAME != C.TABLE_NAME
                                 )
    WHERE   C.TABLE_CATALOG = @DB
            AND C.TABLE_SCHEMA = @SCHEMA
            AND C.TABLE_NAME LIKE @TABLE