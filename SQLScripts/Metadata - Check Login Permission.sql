Select 
               'Login Name'= Substring(upper(SUSER_SNAME(SID)),1,40),
               'Login Create Date'=Convert(Varchar(24),CreateDate),
               'System Admin' = Case SysAdmin
                                               When 1 then 'YES (VERIFY)'
                                               When 0 then 'NO'
               End,
               'Security Admin' = Case SecurityAdmin
                                               When 1 then 'YES (VERIFY)'
                                               When 0 then 'NO'
               End,
               'Server Admin' = Case ServerAdmin
                                               When 1 then 'YES (VERIFY)'
                                               When 0 then 'NO'
               End,
               'Setup Admin' = Case SetupAdmin
                                               When 1 then 'YES (VERIFY)'
                                               When 0 then 'NO'
               End,
               'Process Admin' = Case ProcessAdmin
                                               When 1 then 'YES (VERIFY)'
                                               When 0 then 'NO'
               End,
               'Disk Admin' = Case DiskAdmin
                                               When 1 then 'YES (VERIFY)'
                                               When 0 then 'NO'
               End,
               'Database Creator' = Case DBCreator
                                               When 1 then 'YES (VERIFY)'
                                               When 0 then 'NO'
               End
               from Master.Sys.SysLogins order by 3 desc
