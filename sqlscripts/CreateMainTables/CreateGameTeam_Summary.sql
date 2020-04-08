Create Procedure create_gameteam_summary

AS

Create Table GameTeam_Summary
(
	GameKey					int			not null		,
	GameDateKey				int			not null		,
	TeamID					char(3)		not null		,
	YearID					smallint	not null		,
	TeamGameNumber			tinyint		not null		,
	TeamStartingPitcherKey	int							,
	IsHome					bit							,
	TeamScore				smallint					,
	IsWin					bit							,
	IsDoubleHeader			bit							,
	IsShortenedGame			bit							,
	Primary Key (GameKey, TeamID, YearID)
)

Go