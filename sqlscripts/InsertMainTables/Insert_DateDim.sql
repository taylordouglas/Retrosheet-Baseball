Create Procedure insert_datedim
	@StartDate Date = '19500101',
	@NumberOfYears INT = 90

AS

Drop table if exists #dim
CREATE TABLE #dim
(
  [date]       DATE PRIMARY KEY, 
  [day]        AS DATEPART(DAY,      [date]),
  [month]      AS DATEPART(MONTH,    [date]),
  FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),
  [MonthName]  AS DATENAME(MONTH,    [date]),
  [week]       AS DATEPART(WEEK,     [date]),
  [ISOweek]    AS DATEPART(ISO_WEEK, [date]),
  [DayOfWeek]  AS DATEPART(WEEKDAY,  [date]),
  DayOfWeekName AS DateName(dw, [date]),
  [quarter]    AS DATEPART(QUARTER,  [date]),
  [year]       AS DATEPART(YEAR,     [date]),
  FirstOfYear  AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [date]), 0)),
  Style112     AS CONVERT(CHAR(8),   [date], 112),
  Style101     AS CONVERT(CHAR(10),  [date], 101)
);

-- use the catalog views to generate as many rows as we need

DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate)

INSERT #dim([date]) 
SELECT d
FROM
(
  SELECT d = DATEADD(DAY, rn - 1, @StartDate)
  FROM 
  (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate)) 
      rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    -- on my system this would support > 5 million days
    ORDER BY s1.[object_id]
  ) AS x
) AS y

Insert into Date_dim

Select Cast(d.Style112 as int) as DateKey
	, d.date
	, d.Day
	, d.Month
	, d.MonthName
	, d.week as WeekOfMonth
	, d.DayOfWeek
	, d.DayOfWeekName
	, Case when d.DayOfWeek between 2 and 6 then 1 else 0 end as IsWeekDay
	, d.year
	, Null
From #dim d
	left join Date_dim dd
		on d.date = dd.Date
WHERE dd.date is null

Go