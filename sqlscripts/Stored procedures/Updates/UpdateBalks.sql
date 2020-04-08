Create Procedure update_balk_main

As

with Balk as
(
 SELECT pbp.*
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
	left join work.ActionByCount abc
		on abc.GameID = pbp.GameID
		and abc.NonBatterEventNum = pbp.EventNum
  where EventType = 11
  and abc.GameID is null
)


  Update work.ActionByCount
  set isbalk = 1, NonBatterEventNum = b.EventNum
  FROM Balk b
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
		--and left(pbp.pitchsequence, len(b.pitchsequence)) = b.PitchSequence
  Where (ISNULL(isbalk,0) != 1 or NonBatterEventNum is null)

  Go