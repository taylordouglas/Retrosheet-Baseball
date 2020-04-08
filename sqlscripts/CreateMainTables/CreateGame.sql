Create Procedure creat_gamefact

As

Create Table GameFact

(
	GameKey					int				not null	Identity(1,1) Primary Key	,
	GameDateKey				int				not null								,
	YearID					smallint		not null								,
	WinningTeamID			char(3)			not null								,												
	HomeTeamID				char(3)			not null								,
	HomeGameNumber			tinyint													,
	HomeStartingPitcherKey	int														,													
	HomeFinalScore			smallint		not null								,
	AwayTeamID				char(3)			not null								,
	AwayGameNumber			tinyint													,
	AwayStartingPitcherKey	int														,
	AwayFinalScore			smallint		not null								,
	FinalInning				smallint		not null								,
	FinalBatterKey			int														,
	FinalPitcherKey			int														,
	FinalBattingTeam		bit														,
	WinningPitcherKey		int														,
	LosingPitcherKey		int														,
	ClosingPitcherKey		int														,
	IsWalkOffHomeRun		bit														,
	IsWalkOff				bit														,
	IsExtraInningGame		bit														,
	IsDoubleHeader			bit														,
	GameOfDoubleHeader		tinyint													,
	IsShortenedGame			bit														,
	Retro_GameID			varchar(25)		not null								,
	IsPostseason			bit														,
	Constraint Unique_GameRecord Unique (Retro_GameID)
)

Go