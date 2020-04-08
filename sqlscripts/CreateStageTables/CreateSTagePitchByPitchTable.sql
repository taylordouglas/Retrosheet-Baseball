Create Procedure create_stage_pitchbypitch

As

Create Table stage.PitchByPitch

(
	GameId	varchar(25) not null,
	EventNum int not null,
	SequenceNumber int not null,
	Pitch varchar(2),
	Primary Key (Gameid, EventNum, SequenceNumber) 
)

Go