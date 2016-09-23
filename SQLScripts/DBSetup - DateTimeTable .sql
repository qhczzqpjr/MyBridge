USE DB
GO
IF OBJECT_ID('DateBase_Computed') IS NOT NULL
    DROP TABLE DateBase_Computed

CREATE TABLE [dbo].[DateBase_Computed]
    (
      [CalendarDate] [DATE] NULL ,
      [DateId] AS ( COALESCE(CONVERT([BIGINT], CONVERT([BIGINT], CONVERT([NVARCHAR](MAX), [CalendarDate], ( 112 )), ( 0 ))
                             * ( 10000 ), ( 0 )),
                             CONVERT([BIGINT], ( 0 ), ( 0 ))) ) PERSISTED
                                                              NOT NULL ,
      [CalendarYear] AS ( CONVERT([SMALLINT], DATEPART(YEAR, [CalendarDate]), ( 0 )) )
        PERSISTED ,
      [CalendarQuarterOfYear] AS ( CONVERT([TINYINT], DATEPART(QUARTER,
                                                              [CalendarDate]), ( 0 )) )
        PERSISTED ,
      [CalendarMonthOfYear] AS ( CONVERT([TINYINT], DATEPART(MONTH,
                                                             [CalendarDate]), ( 0 )) )
        PERSISTED ,
      [CalendarMonthOfQuarter] AS ( CONVERT([TINYINT], DATEPART(MONTH,
                                                              [CalendarDate])
                                    - ( DATEPART(QUARTER, [CalendarDate])
                                        - ( 1 ) ) * ( 3 ), ( 0 )) ) PERSISTED ,
      [CalendarWeekOfYear] AS ( CONVERT([TINYINT], DATEPART(WEEK,
                                                            [CalendarDate]), ( 0 )) ) ,
      [CalendarIsoWeek] AS ( CONVERT([TINYINT], DATEPART(iso_week,
                                                         [CalendarDate]), ( 0 )) )
        PERSISTED ,
      [CalendarDayOfYear] AS ( CONVERT([SMALLINT], DATEPART(DAYOFYEAR,
                                                            [CalendarDate]), ( 0 )) )
        PERSISTED ,
      [CalendarDayOfQuarter] AS ( CONVERT([SMALLINT], DATEDIFF(DAY,
                                                              DATEADD(QUARTER,
                                                              DATEPART(QUARTER,
                                                              [CalendarDate])
                                                              - ( 1 ),
                                                              DATEFROMPARTS(DATEPART(YEAR,
                                                              [CalendarDate]),
                                                              ( 1 ), ( 1 ))),
                                                              [CalendarDate]), ( 0 )) )
        PERSISTED ,
      [CalendarDayOfMonth] AS ( CONVERT([TINYINT], DATEPART(DAY,
                                                            [CalendarDate]), ( 0 )) )
        PERSISTED ,
      [CalendarDayOfWeek] AS ( CONVERT([TINYINT], DATEPART(WEEKDAY,
                                                           [CalendarDate]), ( 0 )) ) ,
      [FiscalYear] [SMALLINT] NULL ,
      [FiscalQuarterOfYear] [TINYINT] NULL ,
      [FiscalMonthOfYear] [TINYINT] NULL ,
      [FiscalMonthOfQuarter] [TINYINT] NULL ,
      [FiscalWeekOfYear] [TINYINT] NULL ,
      [FiscalWeekOfQuarter] [TINYINT] NULL ,
      [FiscalWeekOfMonth] [TINYINT] NULL ,
      [FiscalDayOfYear] [SMALLINT] NULL ,
      [FiscalDayOfQuarter] [TINYINT] NULL ,
      [FiscalDayOfMonth] [TINYINT] NULL ,
      [FiscalDayOfWeek] [TINYINT] NULL ,
      [ReportingYear] [SMALLINT] NULL ,
      [ReportingQuarterOfYear] [TINYINT] NULL ,
      [ReportingMonthOfYear] [TINYINT] NULL ,
      [ReportingMonthOfQuarter] [TINYINT] NULL ,
      [ReportingWeekOfYear] [TINYINT] NULL ,
      [ReportingWeekOfQuarter] [TINYINT] NULL ,
      [ReportingWeekOfMonth] [TINYINT] NULL ,
      [ReportingDayOfYear] [SMALLINT] NULL ,
      [ReportingDayOfQuarter] [TINYINT] NULL ,
      [ReportingDayOfMonth] [TINYINT] NULL ,
      [ReportingDayOfWeek] [TINYINT] NULL ,
      [ReportingWeekId] [SMALLINT] NULL ,
      [CalendarDayFullName] AS ( CASE DATEPART(WEEKDAY, [CalendarDate])
                                   WHEN ( 1 ) THEN 'Sunday'
                                   WHEN ( 2 ) THEN 'Monday'
                                   WHEN ( 3 ) THEN 'Tuesday'
                                   WHEN ( 4 ) THEN 'Wednesday'
                                   WHEN ( 5 ) THEN 'Thursday'
                                   WHEN ( 6 ) THEN 'Friday'
                                   WHEN ( 7 ) THEN 'Saturday'
                                 END ) ,
      [CalendarDayShortName] AS ( CASE DATEPART(WEEKDAY, [CalendarDate])
                                    WHEN ( 1 ) THEN 'Sun'
                                    WHEN ( 2 ) THEN 'Mon'
                                    WHEN ( 3 ) THEN 'Tue'
                                    WHEN ( 4 ) THEN 'Wed'
                                    WHEN ( 5 ) THEN 'Thu'
                                    WHEN ( 6 ) THEN 'Fri'
                                    WHEN ( 7 ) THEN 'Sat'
                                  END ) ,
      [CalendarMonthShortName] AS ( CASE DATEPART(MONTH, [CalendarDate])
                                      WHEN ( 1 ) THEN 'Jan'
                                      WHEN ( 2 ) THEN 'Feb'
                                      WHEN ( 3 ) THEN 'Mar'
                                      WHEN ( 4 ) THEN 'Apr'
                                      WHEN ( 5 ) THEN 'May'
                                      WHEN ( 6 ) THEN 'Jun'
                                      WHEN ( 7 ) THEN 'Jul'
                                      WHEN ( 8 ) THEN 'Aug'
                                      WHEN ( 9 ) THEN 'Sep'
                                      WHEN ( 10 ) THEN 'Oct'
                                      WHEN ( 11 ) THEN 'Nov'
                                      WHEN ( 12 ) THEN 'Dec'
                                    END ) ,
      [FiscalDayFullName] AS ( CASE [FiscalDayOfWeek]
                                 WHEN ( 2 ) THEN 'Sunday'
                                 WHEN ( 3 ) THEN 'Monday'
                                 WHEN ( 4 ) THEN 'Tuesday'
                                 WHEN ( 5 ) THEN 'Wednesday'
                                 WHEN ( 6 ) THEN 'Thursday'
                                 WHEN ( 7 ) THEN 'Friday'
                                 WHEN ( 1 ) THEN 'Saturday'
                               END ) ,
      [FiscalDayShortName] AS ( CASE [FiscalDayOfWeek]
                                  WHEN ( 2 ) THEN 'Sun'
                                  WHEN ( 3 ) THEN 'Mon'
                                  WHEN ( 4 ) THEN 'Tue'
                                  WHEN ( 5 ) THEN 'Wed'
                                  WHEN ( 6 ) THEN 'Thu'
                                  WHEN ( 7 ) THEN 'Fri'
                                  WHEN ( 1 ) THEN 'Sat'
                                END ) ,
      [FiscalMonthShortName] AS ( CASE [FiscalMonthOfYear]
                                    WHEN ( 7 ) THEN 'Jan'
                                    WHEN ( 8 ) THEN 'Feb'
                                    WHEN ( 9 ) THEN 'Mar'
                                    WHEN ( 10 ) THEN 'Apr'
                                    WHEN ( 11 ) THEN 'May'
                                    WHEN ( 12 ) THEN 'Jun'
                                    WHEN ( 1 ) THEN 'Jul'
                                    WHEN ( 2 ) THEN 'Aug'
                                    WHEN ( 3 ) THEN 'Sep'
                                    WHEN ( 4 ) THEN 'Oct'
                                    WHEN ( 5 ) THEN 'Nov'
                                    WHEN ( 6 ) THEN 'Dec'
                                  END ) ,
      [ReportingDayFullName] AS ( CASE [ReportingDayOfWeek]
                                    WHEN ( 2 ) THEN 'Sunday'
                                    WHEN ( 3 ) THEN 'Monday'
                                    WHEN ( 4 ) THEN 'Tuesday'
                                    WHEN ( 5 ) THEN 'Wednesday'
                                    WHEN ( 6 ) THEN 'Thursday'
                                    WHEN ( 7 ) THEN 'Friday'
                                    WHEN ( 1 ) THEN 'Saturday'
                                  END ) ,
      [ReportingDayShortName] AS ( CASE [ReportingDayOfWeek]
                                     WHEN ( 2 ) THEN 'Sun'
                                     WHEN ( 3 ) THEN 'Mon'
                                     WHEN ( 4 ) THEN 'Tue'
                                     WHEN ( 5 ) THEN 'Wed'
                                     WHEN ( 6 ) THEN 'Thu'
                                     WHEN ( 7 ) THEN 'Fri'
                                     WHEN ( 1 ) THEN 'Sat'
                                   END ) ,
      [CalendarQuarterName] AS ( 'Q' + CONVERT([CHAR](1), DATEPART(QUARTER,
                                                              [CalendarDate]), ( 0 )) ) ,
      [FiscalQuarterName] AS ( 'Q' + CONVERT([CHAR](1), [FiscalQuarterOfYear], ( 0 )) ) ,
      [ReportingWeekName] AS ( 'W'
                               + CONVERT([VARCHAR](2), [ReportingWeekOfYear], ( 0 )) ) ,
      [ReportingWeekStartDate] AS ( DATEADD(DAY, ( 1 ) - [ReportingDayOfWeek],
                                            [CalendarDate]) ) ,
      [ReportingWeekEndDate] AS ( DATEADD(DAY, ( 7 ) - [ReportingDayOfWeek],
                                          [CalendarDate]) ) ,
      [CalendarWeekName] AS ( 'W' + RIGHT('00'
                                          + CONVERT([VARCHAR](2), DATEPART(WEEK,
                                                              [CalendarDate]), ( 0 )),
                                          ( 2 )) ) ,
      [CalendarYearName] AS ( 'CY' + RIGHT('00'
                                           + CONVERT([VARCHAR](2), DATEPART(YEAR,
                                                              [CalendarDate])
                                           % ( 100 ), ( 0 )), ( 2 )) ) ,
      [FiscalWeekName] AS ( 'W' + RIGHT('00'
                                        + CONVERT([VARCHAR](2), [FiscalWeekOfYear], ( 0 )),
                                        ( 2 )) ) ,
      [FiscalYearName] AS ( 'FY' + RIGHT('00'
                                         + CONVERT([VARCHAR](2), [FiscalYear]
                                         % ( 100 ), ( 0 )), ( 2 )) ) ,
      [FiscalMonthFullName] AS ( CASE [FiscalMonthOfYear]
                                   WHEN ( 7 ) THEN 'January'
                                   WHEN ( 8 ) THEN 'February'
                                   WHEN ( 9 ) THEN 'March'
                                   WHEN ( 10 ) THEN 'April'
                                   WHEN ( 11 ) THEN 'May'
                                   WHEN ( 12 ) THEN 'June'
                                   WHEN ( 1 ) THEN 'July'
                                   WHEN ( 2 ) THEN 'August'
                                   WHEN ( 3 ) THEN 'September'
                                   WHEN ( 4 ) THEN 'October'
                                   WHEN ( 5 ) THEN 'November'
                                   WHEN ( 6 ) THEN 'December'
                                 END ) ,
      [CalendarMonthFullName] AS ( CASE DATEPART(MONTH, [CalendarDate])
                                     WHEN ( 1 ) THEN 'January'
                                     WHEN ( 2 ) THEN 'February'
                                     WHEN ( 3 ) THEN 'March'
                                     WHEN ( 4 ) THEN 'April'
                                     WHEN ( 5 ) THEN 'May'
                                     WHEN ( 6 ) THEN 'June'
                                     WHEN ( 7 ) THEN 'July'
                                     WHEN ( 8 ) THEN 'August'
                                     WHEN ( 9 ) THEN 'September'
                                     WHEN ( 10 ) THEN 'October'
                                     WHEN ( 11 ) THEN 'November'
                                     WHEN ( 12 ) THEN 'December'
                                   END ) ,
      CONSTRAINT [PK_DateBase_Computed] PRIMARY KEY CLUSTERED ( [DateId] ASC )
        WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
               IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
               ALLOW_PAGE_LOCKS = ON )
    );
WITH    t1 ( t )
          AS ( SELECT   1
               FROM     sys.objects
               WHERE    type = 'S'
             ),
        t2 ( t )
          AS ( SELECT   1
               FROM     t1 ,
                        t1 t
             ),
        t3 ( t )
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY ( SELECT 1
                                                     ) )
               FROM     t2 ,
                        t2 t
             )
    INSERT  DateBase_Computed
            ( CalendarDate
            )
            SELECT  DATEADD(dd, t, '1900-01-01')
            FROM    t3
            WHERE   t <= DATEDIFF(dd, '1900-01-01', '2100-01-01')
 
 --Check
SELECT  *
FROM    DateBase_Computed (NOLOCK)



GO
IF OBJECT_ID('TimeBase_Computed') IS NOT NULL
    DROP TABLE TimeBase_Computed

CREATE TABLE dbo.[TimeBase_Computed]
    (
      [MinutesFromMidnight] [SMALLINT] NOT NULL ,
      [TimeId] AS ( CONVERT([SMALLINT], CONVERT([SMALLINT], [MinutesFromMidnight]
                    / ( 60 ), ( 0 )) * ( 100 )
                    + CONVERT([SMALLINT], [MinutesFromMidnight] % ( 60 ), ( 0 )), ( 0 )) )
        PERSISTED
        NOT NULL ,
      [Hour] AS ( CONVERT([TINYINT], [MinutesFromMidnight] / ( 60 ), ( 0 )) )
        PERSISTED
        NOT NULL ,
      [Minute] AS ( CONVERT([TINYINT], [MinutesFromMidnight] % ( 60 ), ( 0 )) )
        PERSISTED
        NOT NULL ,
      [IsPm] AS ( CONVERT([BIT], CASE WHEN CONVERT([TINYINT], [MinutesFromMidnight]
                                           / ( 60 ), ( 0 )) >= ( 12 )
                                      THEN ( 1 )
                                      ELSE ( 0 )
                                 END, ( 0 )) ) PERSISTED
                                               NOT NULL ,
      [05MinuteIntervalId] AS ( CONVERT([SMALLINT], [MinutesFromMidnight]
                                / ( 5 ), ( 0 )) ) PERSISTED
                                                  NOT NULL ,
      [10MinuteIntervalId] AS ( CONVERT([SMALLINT], [MinutesFromMidnight]
                                / ( 10 ), ( 0 )) ) PERSISTED
                                                   NOT NULL ,
      [15MinuteIntervalId] AS ( CONVERT([SMALLINT], [MinutesFromMidnight]
                                / ( 15 ), ( 0 )) ) PERSISTED
                                                   NOT NULL ,
      [30MinuteIntervalId] AS ( CONVERT([SMALLINT], [MinutesFromMidnight]
                                / ( 30 ), ( 0 )) ) PERSISTED
                                                   NOT NULL ,
      [12HourName] AS ( CASE WHEN CONVERT([TINYINT], [MinutesFromMidnight]
                                  / ( 60 ), ( 0 )) = ( 0 )
                             THEN ( '12:'
                                    + RIGHT(CONVERT([VARCHAR](3), [MinutesFromMidnight]
                                            % ( 60 ) + ( 100 ), ( 0 )), ( 2 )) )
                                  + ' AM'
                             WHEN CONVERT([TINYINT], [MinutesFromMidnight]
                                  / ( 60 ), ( 0 )) < ( 12 )
                             THEN ( ( RIGHT(CONVERT([VARCHAR](3), CONVERT([TINYINT], [MinutesFromMidnight]
                                            / ( 60 ), ( 0 )) + ( 100 ), ( 0 )),
                                            ( 2 )) + ':' )
                                    + RIGHT(CONVERT([VARCHAR](3), [MinutesFromMidnight]
                                            % ( 60 ) + ( 100 ), ( 0 )), ( 2 )) )
                                  + ' AM'
                             ELSE ( ( RIGHT(CONVERT([VARCHAR](3), CONVERT([TINYINT], [MinutesFromMidnight]
                                            / ( 60 ) - ( 12 ), ( 0 ))
                                            + ( 100 ), ( 0 )), ( 2 )) + ':' )
                                    + RIGHT(CONVERT([VARCHAR](3), [MinutesFromMidnight]
                                            % ( 60 ) + ( 100 ), ( 0 )), ( 2 )) )
                                  + ' PM'
                        END ) PERSISTED
                              NOT NULL ,
      [24HourName] AS ( ( RIGHT(CONVERT([VARCHAR](3), CONVERT([TINYINT], [MinutesFromMidnight]
                                / ( 60 ), ( 0 )) + ( 100 ), ( 0 )), ( 2 ))
                          + ':' )
                        + RIGHT(CONVERT([VARCHAR](3), [MinutesFromMidnight]
                                % ( 60 ) + ( 100 ), ( 0 )), ( 2 )) ) PERSISTED
                                                              NOT NULL ,
      CONSTRAINT [PK_TimeBase_Computed] PRIMARY KEY CLUSTERED ( [TimeId] ASC )
        WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
               IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
               ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
    )
ON  [PRIMARY];
WITH    t1 ( t )
          AS ( SELECT   1
               FROM     sys.objects
               WHERE    type = 'S'
             ),
        t2 ( t )
          AS ( SELECT   1
               FROM     t1 ,
                        t1 t
             ),
        t3 ( t )
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY ( SELECT 1
                                                     ) )
               FROM     t2 ,
                        t2 t
             )
    INSERT  [TimeBase_Computed]
            ( [MinutesFromMidnight] )
            SELECT  t - 1
            FROM    t3
            WHERE   t <= 1440

--check
SELECT  *
FROM    [TimeBase_Computed]




IF OBJECT_ID('DateTimeMapping') IS NOT NULL
    DROP TABLE DateTimeMapping

CREATE TABLE DateTimeMapping
    (
      DateTimeId BIGINT ,
      DateId BIGINT ,
      TimeId SMALLINT ,
      CONSTRAINT [PK_DateTimeMapping] PRIMARY KEY CLUSTERED ( DateTimeId ASC )--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    )--GO