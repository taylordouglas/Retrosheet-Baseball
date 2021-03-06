Use Retrosheet
go

  Update work.ActionByCount
  set IsAttemptedSteal = 1, NonBatterEventNum = pbp.EventNum
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
	join work.ActionByCount abc
		on pbp.GameID = abc.GameID
		and pbp.EventNum = abc.Eventnum - 1
		and abc.SequenceNumber = LEN(PitchSequence)
  where BatterEventFlag = 'F'
  and eventtype in (4,6)
  and OutsOnPlay + Outs < 3
  and PitchCode = SUBSTRING(PitchSequence, SequenceNumber, 1)
  and NonBatterEventNum is null
  --and RIGHT(PitchSequence, 1) = 'N'