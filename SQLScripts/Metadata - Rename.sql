/*
Syntax
    sp_rename [ @objname = ] 'object_name' , [ @newname = ] 'new_name' [ , [ @objtype = ] 'object_type' ] 
Arguments
    [ @objname = ] 'object_name'
        Is the current qualified or nonqualified name of the user object or data type. If the object to be renamed is a column in a table, object_name must be in the form table.column or schema.table.column. If the object to be renamed is an index, object_name must be in the form table.index or schema.table.index. If the object to be renamed is a constraint, object_name must be in the form schema.constraint.
        Quotation marks are only necessary if a qualified object is specified. If a fully qualified name, including a database name, is provided, the database name must be the name of the current database. object_name is nvarchar(776), with no default.
    [ @newname = ] 'new_name'
        Is the new name for the specified object. new_name must be a one-part name and must follow the rules for identifiers. newname is sysname, with no default.
        System_CAPS_noteNote
        Trigger names cannot start with # or ##.
    [ @objtype = ] 'object_type'
        Is the type of object being renamed. object_type is varchar(13), with a default of NULL, and can be one of these values.
        COLUMN
            A column to be renamed.
        DATABASE
            A user-defined database. This object type is required when renaming a database.
        INDEX
            A user-defined index. Renaming an index with statistics, also automatically renames the statistics.
        OBJECT
            An item of a type tracked in sys.objects. For example, OBJECT could be used to rename objects including constraints (CHECK, FOREIGN KEY, PRIMARY/UNIQUE KEY), user tables, and rules.
        STATISTICS
            Statistics created explicitly by a user or created implicitly with an index. Renaming the statistics of an index automatically renames the index as well.
            Applies to: SQL Server 2012 through SQL Server 2016 and Azure SQL Database.
        USERDATATYPE
            A CLR User-defined Types added by executing CREATE TYPE or sp_addtype.
*/
sp_rename '','',''