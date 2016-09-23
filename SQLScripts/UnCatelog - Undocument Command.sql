/*

Undocumented Trace Flags

To summarize the flags used in this series (all assume 3604 is also active):
DBCC TRACEON()
DBCC TRACEOFF()

https://support.microsoft.com/en-us/kb/2801413

7352 : Final query tree 
8605 : Converted tree 
8606 : Input, simplified, join-collapsed, and normalized trees 
8607 : Output tree 
8608 : Initial memo 
8615 : Final memo 
8675 : Optimization stages and times

The above were used in the presentation because they all work from 2005 to 2012.  There are a large number of other optimizer-related flags (some of which only work on 2012).  Some are listed below for people that like this sort of thing:

2373 : Memory before and after deriving properties and rules (verbose) 
7357 : Unique hash optimization used 
8609 : Task and operation type counts 
8619 : Apply rule with description 
8620 : Add memo arguments to 8619 
8621 : Rule with resulting tree


Undocumented DBCC commands

Here you can find some useful undocumented DBCC commands.

	sp_msforeachdb 'print ''?'''
	sp_Msforeachtable
	has_dbaccess('speed') 
	DATABASEPROPERTY('speed', 'issingleuser')


1. DBCC BUFFER

This command can be used to display buffer headers and pages from the buffer cache.

Syntax:

dbcc buffer ([dbid~dbname] [,objid~objname] [,nbufs], [printopt])

where

  dbid~dbname   - database id~database name
  objid~objname - object id~object name
  nbufs         - number of buffers to examine
  printopt      - print option
                  0 - print out only the buffer header and page header
                      (default)
                  1 - print out each row separately and the offset table
                  2 - print out each row as a whole and the offset table
This is the example:

DBCC TRACEON (3604)
dbcc buffer(master,'sysobjects')
2. DBCC BYTES

This command can be used to dump out bytes from a specific address.

Syntax:

dbcc bytes ( startaddress, length )

where

  startaddress  - starting address to dump  
  length        - number of bytes to dump
This is the example:

DBCC TRACEON (3604)
dbcc bytes (10000000, 100)
3. DBCC DBINFO

Displays DBINFO structure for the specified database.

Syntax:

DBCC DBINFO [( dbname )]

where

  dbname - is the database name.
This is the example:

DBCC TRACEON (3604)
DBCC DBINFO (master)
4. DBCC DBTABLE

This command displays the contents of the DBTABLE structure.

Syntax:

DBCC DBTABLE ({dbid~dbname})

where 

  dbid~dbname  - database name or database ID
This is the example:

DBCC TRACEON (3604)
DBCC DBTABLE (master)
The DBTABLE structure has an output parameter called dbt_open. This parameter keeps track of how many users are in the database.

Look at here for more details:
FIX: Database Usage Count Does Not Return to Zero

5. DBCC DES

Prints the contents of the specified DES (descriptor).

Syntax:

dbcc des [( [dbid~dbname] [,objid~objname] )]

where

dbid~dbname   - database id~database name.
objid~objname - object id~object name
This is the example:

DBCC TRACEON (3604)
DBCC DES
6. DBCC HELP

DBCC HELP returns syntax information for the specified DBCC statement. In comparison with DBCC HELP command in version 6.5, it returns syntax information only for the documented DBCC commands.

Syntax:

DBCC HELP ('dbcc_statement' ~ @dbcc_statement_var ~ '?')

This is the example:

DBCC TRACEON (3604)
DECLARE @dbcc_stmt sysname
SELECT @dbcc_stmt = 'CHECKTABLE'
DBCC HELP (@dbcc_stmt)
7. DBCC IND

Shows all pages in use by indexes of the specified table.

Syntax:

dbcc ind( dbid~dbname, objid~objname, printopt = {-2~-1~0~1~2~3} )

where

  dbid~dbname   - database id~database name.
  objid~objname - object id~object name
  printopt      - print option
There is change in this command in how it is used in SQL Server 7.0, in that the printopt parameter is now no longer optional.

This is the example:

DBCC TRACEON (3604)
DBCC IND (master, sysobjects, 0)
8. DBCC log

This command is used to view the transaction log for the specified database.

Syntax:

DBCC log ( {dbid~dbname}, [, type={-1~0~1~2~3~4}] )

PARAMETERS: 
   Dbid or dbname - Enter either the dbid or the name of the database
                    in question.

      type - is the type of output:

      0 - minimum information (operation, context, transaction id)

      1 - more information (plus flags, tags, row length, description)

      2 - very detailed information (plus object name, index name,
          page id, slot id)

      3 - full information about each operation

      4 - full information about each operation plus hexadecimal dump
          of the current transaction log's row.

     -1 - full information about each operation plus hexadecimal dump
          of the current transaction log's row, plus Checkpoint Begin,
          DB Version, Max XDESID

by default type = 0
To view the transaction log for the master database, run the following command:

DBCC log (master)

9. DBCC PAGE

You can use this command to view the data page structure.

Syntax:

DBCC PAGE ({dbid~dbname}, pagenum [,print option] [,cache] [,logical])

PARAMETERS: 
   Dbid or dbname - Enter either the dbid or the name of the database
                    in question.

   Pagenum - Enter the page number of the SQL Server page that is to
             be examined.

   Print option - (Optional) Print option can be either 0, 1, or 2.

                  0 - (Default) This option causes DBCC PAGE to print
                      out only the page header information.
                  1 - This option causes DBCC PAGE to print out the
                      page header information, each row of information
                      from the page, and the page's offset table. Each
                      of the rows printed out will be separated from
                      each other.
                  2 - This option is the same as option 1, except it
                      prints the page rows as a single block of
                      information rather than separating the
                      individual rows. The offset and header will also
                      be displayed.

   Cache - (Optional) This parameter allows either a 1 or a 0 to be
           entered.
           0 - This option causes DBCC PAGE to retrieve the page
               number from disk rather than checking to see if it is
               in cache.
           1 - (Default) This option takes the page from cache if it
               is in cache rather than getting it from disk only.

   Logical - (Optional) This parameter is for use if the page number
             that is to be retrieved is a virtual page rather then a
             logical page. It can be either 0 or 1.

             0 - If the page is to be a virtual page number.
             1 - (Default) If the page is the logical page number.
This is the example:

DBCC TRACEON (3604)
DBCC PAGE (master, 1, 1)
Look at here for more details:
Data page structure in MS SQL 6.5

10. DBCC procbuf

This command displays procedure buffer headers and stored procedure headers from the procedure cache.

Syntax:

DBCC procbuf( [dbid~dbname], [objid~objname], [nbufs], [printopt = {0~1}] )

where

  dbid~dbname   - database id~database name.
  objid~objname - object id~object name
  nbufs         - number of buffers to print    
  printopt - print option
             (0  print out only the proc buff and proc header (default)  
              1  print out proc buff, proc header and contents of buffer)
This is the example:

DBCC TRACEON (3604)
DBCC procbuf(master,'sp_help',1,0)
11. DBCC prtipage

This command prints the page number pointed to by each row on the specified index page.

Syntax:

DBCC prtipage( dbid, objid, indexid, indexpage )

where

  dbid      - database ID  
  objid     - object ID  
  indexid   - index ID  
  indexpage - the logical page number of the index page to dump
This is the example:

DBCC TRACEON (3604)
DECLARE @dbid int, @objectid int
SELECT @dbid = DB_ID('master')
SELECT @objectid = object_id('sysobjects')
DBCC prtipage(@dbid,@objectid,1,0)
12. DBCC pss

This command shows info about processes currently connected to the server.

Syntax:

DBCC pss( suid, spid, printopt = { 1 ~ 0 } )

where

  suid     - server user ID     
  spid     - server process ID    
  printopt - print option
             (0  standard output,
              1  all open DES's and current sequence tree)
This is the example:

DBCC TRACEON (3604)
dbcc pss
13. DBCC resource

This command shows the server's level RESOURCE, PERFMON and DS_CONFIG information. RESOURCE shows addresses of various data structures used by the server. PERFMON structure contains master..spt_monitor field info. DS_CONFIG structure contains master..syscurconfigs field information.

Syntax:

DBCC resource

This is the example:

DBCC TRACEON (3604)
DBCC resource
14. DBCC TAB

You can use the following undocumented command to view the data pages structure (in comparison with DBCC PAGE, this command will return information about all data pages for viewed table, not only for particular number).

Syntax:

DBCC tab (dbid, objid)

where

  dbid  - is the database id
  objid - is the table id
This is the example:

DBCC TRACEON (3604)
DECLARE @dbid int, @objectid int
SELECT @dbid = DB_ID('master')
SELECT @objectid = object_id('sysdatabases')
DBCC TAB (@dbid,@objectid)
*/