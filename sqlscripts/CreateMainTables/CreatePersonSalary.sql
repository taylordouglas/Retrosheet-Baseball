Create Procedure create_personsalary

AS

Create Table PersonSalary
(
	PersonKey		int				not null	Foreign Key References Person(PersonKey)	,
	TeamID			char(3)			not null												,
	YearID			smallint		not null												,
	Salary			int																		,
	Primary Key (PersonKey, TeamID, YearID)													,
	--Constraint fk_PersonSalary_TeamYear Foreign Key (TeamID, YearID) References Team(TeamID,YearID)
)

GO