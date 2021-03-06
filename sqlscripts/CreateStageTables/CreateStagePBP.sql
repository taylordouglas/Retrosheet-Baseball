Create Procedure create_stage_play

AS

Create Table stage.PlayByPlay
	(
		GameID								varchar(25)				not null,
		VisitingTeam						varchar(5)				null,
		Inning								int						null,
		BattingTeam							int						null,
		Outs								int						null,
		Balls								int						null,	
		Strikes								int						null,
		PitchSequence						varchar(50)				null,
		VisitorScore						int						null,
		HomeScore							int						null,
		Batter								varchar(20)				null,
		BatterHand							varchar(3)				null,
		ResBatter							varchar(20)				null,
		ResBatterHand						varchar(3)				null,
		Pitcher								varchar(20)				null,
		PitcherHand							varchar(3)				null,
		ResPitcher							varchar(20)				null,
		ResPitcherHand						varchar(3)				null,
		Catcher								varchar(20)				null,
		FirstBase							varchar(20)				null,
		SecondBase							varchar(20)				null,
		ThirdBase							varchar(20)				null,
		Shortstop							varchar(20)				null,
		LeftField							varchar(20)				null,
		CenterField							varchar(20)				null,
		RightField							varchar(20)				null,
		FirstRunner							varchar(20)				null,
		SecondRunner						varchar(20)				null,
		ThirdRunner							varchar(20)				null,
		EventText							varchar(max)			null,
		LeadoffFlag							varchar(3)				null,
		PinchHitFlag						varchar(3)				null,
		DefensivePosition					int						null,
		LineupPosition						int						null,
		EventType							int						null,
		BatterEventFlag						varchar(3)				null,
		AbFlag								varchar(3)				null,
		HitValue							int						null,
		SHFlag								varchar(3)				null,
		SFFlag								varchar(3)				null,
		OutsOnPlay							int						null,
		DoublePlayFlag						varchar(3)				null,
		TriplePlayFlag						varchar(3)				null,
		RBIOnPlay							int						null,
		WildPitchFlag						varchar(3)				null,
		PassedBallFlag						varchar(3)				null,
		FieldedBy							int						null,
		BattedBallType						varchar(20)				null,
		BuntFlag							varchar(3)				null,
		FoulFlag							varchar(3)				null,
		HitLocation							varchar(20)				null,
		NumErrors							int						null,
		FirstErrorPlayer					int						null,
		FirstErrorType						varchar(3)				null,
		SecondErrorPlayer					int						null,
		SecondErrorType						varchar(3)				null,
		ThirdErrorPlayer					int						null,
		ThirdErrorType						varchar(3)				null,
		BatterDest							int						null,
		RunnerOn1stDest						int						null,
		RunnerOn2ndDest						int						null,
		RunnerOn3rdDest						int						null,
		PlayOnBatter						varchar(20)				null,
		PlayOnRunnerOn1st					varchar(20)				null,
		PlayOnRunnerOn2nd					varchar(20)				null,
		PlayOnRunnerOn3rd					varchar(20)				null,
		SBForRunnerOn1stFlag				varchar(3)				null,
		SBForRunnerOn2ndFlag				varchar(3)				null,
		SBForRunnerOn3rdFlag				varchar(3)				null,
		CSForRunnerOn1stFlag				varchar(3)				null,
		CSForRunnerOn2ndFlag				varchar(3)				null,
		CSForRunnerOn3rdFlag				varchar(3)				null,
		POForRunnerOn1stFlag				varchar(3)				null,
		POForRunnerOn2ndFlag				varchar(3)				null,
		POForRunnerOn3rdFlag				varchar(3)				null,
		ResponsiblePitcherForRunnerOn1st	varchar(20)				null,
		ResponsiblePitcherForRunnerOn2nd	varchar(20)				null,
		ResponsiblePitcherForRunnerOn3rd	varchar(20)				null,
		NewGameFlag							varchar(3)				null,
		EndGameFlag							varchar(3)				null,
		PinchRunnerOn1st					varchar(20)				null,
		PinchRunnerOn2nd					varchar(20)				null,
		PinchRunnerOn3rd					varchar(20)				null,
		RunnerRemovedForPinchRunnerOn1st	varchar(20)				null,
		RunnerRemovedForPinchRunnerOn2nd	varchar(20)				null,
		RunnerRemovedForPinchRunnerOn3rd	varchar(20)				null,
		BatterRemovedForPinchHitter			varchar(20)				null,
		PositionOfBatterRemovedForPinchHitter	int					null,
		FielderWithFirstPutout 				int						null,
		FielderWithSecondPutout				int						null,
		FielderWithThirdPutout 				int						null,
		FielderWithFirstAssist 				int						null,
		FielderWithSecondAssist				int						null,
		FielderWithThirdAssist 				int						null,
		FielderWithFourthAssist				int						null,
		FielderWithFifthAssist 				int						null,
		EventNum							int						not null,
		Primary Key (GameId, EventNum)
	)
	
Go	