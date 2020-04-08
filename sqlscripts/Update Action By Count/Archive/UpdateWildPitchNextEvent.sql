Use Retrosheet
go

Update work.ActionByCount
  set IsWildPitch = 1, NonBatterEventNum = pbp.EventNum
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
  join work.ActionByCount abc
	on pbp.GameID = abc.GameID
	and pbp.EventNum = abc.Eventnum - 1
	and abc.SequenceNumber = LEN(PitchSequence)
  where WildPitchFlag = 'T'
  and BatterEventFlag = 'F'
  and OutsOnPlay + Outs < 3
  and PitchCode = SUBSTRING(PitchSequence, SequenceNumber, 1)
  and (iswildpitch != 1 or NonBatterEventNum is null)