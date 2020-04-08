Update abc
Set IsBlocked = 1
From work.ActionByCount abc
	join work.ActionByCount prev
		on abc.GameID = prev.GameID
		and abc.Eventnum = prev.Eventnum
		and abc.SequenceNumber = prev.SequenceNumber + 1
		and prev.PitchCode = '*'
