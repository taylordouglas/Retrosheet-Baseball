Use Retrosheet
go

drop table if exists #nbEvents


 SELECT pbp.*
 Into #nbevents
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
	left join work.ActionByCount abc
		on abc.GameID = pbp.GameID
		and abc.NonBatterEventNum = pbp.EventNum
  where EventType in (5, 7, 8, 12, 13)
  and abc.GameID is null

--Begin Tran NonBatterEvents

  Update work.ActionByCount
  set NonBatterEventNum = b.EventNum
  FROM #nbevents b
	join [Retrosheet].[stage].[PlayByPlay] pbp
		on b.GameID = pbp.GameID
		and b.EventNum between pbp.EventNum - 3 and pbp.EventNum
		and b.batter = pbp.Batter
		and b.Inning = pbp.Inning
	join work.ActionByCount abc
		on abc.GameID = pbp.GameID
		and abc.Eventnum = pbp.EventNum
		and abc.SequenceNumber = LEN(b.PitchSequence)
		and abc.PitchCode = SUBSTRING(b.PitchSequence, SequenceNumber, 1)
  Where (NonBatterEventNum is null)

--End

