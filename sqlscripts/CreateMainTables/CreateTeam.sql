Create Procedure create_team

as

Create Table Team

(
	YearID		smallint	not null												,
	TeamID		char(3)		not null												,
	LahmanID	char(3)																,
	BBREFID		char(3)																,
	TeamName	varchar(50)															,
	TeamPark	varchar(80)															,
	TeamLg		char(2)																,
	TeamDiv		char(1)																,
	FranchID	char(3)																,
	Primary Key (YearID, TeamID)
)

Go



