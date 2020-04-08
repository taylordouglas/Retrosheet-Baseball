Update work.ActionByCount
set PrePitchBalls = sub.PostPitchBalls
, PrePitchStrikes = sub.PostPitchStrikes
, PostPitchBalls = sub.PostPitchBalls
, PostPitchStrikes = sub.PostPitchStrikes
from work.ActionByCount abc
Join (Select * from work.ActionByCount) sub
	on abc.GameID = sub.GameID
	and abc.Eventnum = sub.Eventnum
	and abc.SequenceNumber = sub.SequenceNumber + 1
where abc.PrePitchBalls is null