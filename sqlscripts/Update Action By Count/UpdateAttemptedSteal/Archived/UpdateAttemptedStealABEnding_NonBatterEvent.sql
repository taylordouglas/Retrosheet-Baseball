Use Retrosheet
go

Update work.ActionByCount
set IsAttemptedSteal = 1, NonBatterEventNum = pbp.EventNum
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
	join work.ActionByCount	abc
		on abc.GameID = pbp.GameID
		and abc.Eventnum = pbp.EventNum
		and abc.SequenceNumber = LEN(PitchSequence)
  where BatterEventFlag = 'F'
  and eventtype in (4,6)
  and NonBatterEventNum is null