Create Procedure create_datedim

AS

Create Table Date_dim
(
	DateKey				int			not null		Primary Key				,	
	Date				Date		not null								,
	Day					tinyint												,
	Month				tinyint												,
	MonthName			varchar(12)											,
	WeekOfMonth			tinyint												,
	DayOfWeek			tinyint												,
	DayOfWeekName		varchar(10)											,
	IsWeekDay			bit													,
	Year				smallint											,
	IsHoliday			bit													
)

GO