/*
Syntax
    sp_helptext [ @objname = ] 'name' [ , [ @columnname = ] computed_column_name ]
Arguments
    [ @objname = ] 'name'
        Is the qualified or nonqualified name of a user-defined, schema-scoped object. Quotation marks are required only if a qualified object is specified. If a fully qualified name, including a database name, is provided, the database name must be the name of the current database. The object must be in the current database. name is nvarchar(776), with no default.
    [ @columnname = ] 'computed_column_name'
        Is the name of the computed column for which to display definition information. The table that contains the column must be specified as name. column_name is sysname, with no default.
*/
sp_helptext ''