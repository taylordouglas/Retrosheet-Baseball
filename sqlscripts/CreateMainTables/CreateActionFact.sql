Create Procedure create_actionfact

AS

Create Table ActionFact
(
	ActionKey				int		not null	Identity(1,1)								,	
	PlayKey					int		not null												,
	GameKey					int		not null												,
	Eventnum				tinyint	not null												,
	SequenceNum				tinyint	not null												,
	NonBatterPlayKey		int																,
	ActionCode				char(1)															,
	ActionDescription		varchar(100)													,
	PrePitchBalls			tinyint															,
	PrePitchStrikes			tinyint															,
	IsAttemptedSteal		bit																,
	IsWildPitch				bit																,
	IsPassedBall			bit																,
	IsBalk					bit																,
	IsBlocked				bit																,
	IsCatcherPickoff		bit																,
	PostPitchBalls			tinyint															,
	PostPitchStrikes		tinyint															,
	IsFinalAction			bit																,
	Primary Key (ActionKey, PlayKey, SequenceNum)											,
	Constraint Unique_GameEventSequence	Unique (PlayKey, SequenceNum)									
)

GO