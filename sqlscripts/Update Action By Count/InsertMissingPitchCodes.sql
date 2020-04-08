INsert into work.ActionByCount

Select pitch.GameId
	, pitch.EventNum
	, pitch.SequenceNumber
	, pitch.Pitch
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
from stage.PitchByPitch pitch
	left join work.ActionByCount abc
	on pitch.GameId = abc.GameID
	and pitch.EventNum = abc.Eventnum
	and pitch.SequenceNumber  = abc.SequenceNumber

where abc.Eventnum is null
--Order by pitch.GameId, pitch.Eventnum, pitch.SequenceNumber

--Select count(*) from work.ActionByCount
--Select count(*) from stage.PitchByPitch