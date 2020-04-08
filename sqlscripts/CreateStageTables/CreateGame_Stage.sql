Create Procedure create_stage_game

As

Create Table stage.Game

(
	GameId				varchar(25)		not null	Primary Key	,
	GameDate			date			not null				,
	WinningTeam			varchar(5)		not null				,												
	HomeTeam			varchar(5)		not null				,
	HomeGameNumber		tinyint			not null				,
	HomeStartingPitcher	varchar(20)								,													
	HomeFinalScore		smallint		not null				,
	AwayTeam			varchar(5)		not null				,
	AwayGameNumber		tinyint									,
	AwayStartingPitcher	varchar(20)								,
	AwayFinalScore		smallint		not null				,
	FinalInning			smallint		not null				,
	FinalBatter			varchar(20)								,
	FinalPitcher		varchar(20)								,
	FinalBattingTeam	varchar(5)								,
	WinningPitcher		varchar(20)								,
	LosingPitcher		varchar(20)								,
	ClosingPitcher		varchar(20)								,
	IsWalkOffHomeRun	bit										,
	IsWalkOff			bit										,
	IsExtraInningGame	bit										,
	IsDoubleHeader		bit										,
	GameOfDoubleHeader	tinyint									,
	IsShortenedGame		bit										,
	IsPostseason		bit					

)

Go
