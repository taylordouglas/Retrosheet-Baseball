Create Procedure create_manager

AS

Create Table Manager
(
	ManagerKey			int			not null		Foreign Key References Person(PersonKey)	,
	YearID				int			not null													,
	TeamID				char(3)		not null													,
	InSeasonOrdinal		tinyint		not null													,
	FirstGameManagedSZN	tinyint																	,
	LastGameManagedSZN	tinyint																	, 
	Wins				tinyint																	,
	Losses				tinyint																	,
	rank				tinyint																	,
	isPlayerMgr			bit																		,
	Primary Key (ManagerKey, YearID, TeamID, InSeasonOrdinal)
)

GO