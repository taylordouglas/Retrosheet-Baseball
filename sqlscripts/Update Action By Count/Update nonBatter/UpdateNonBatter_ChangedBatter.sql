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
			and (b.batter = pbp.Batter or b.Outs = pbp.Outs)
			and b.Inning = pbp.Inning
		join work.ActionByCount abc
			on abc.GameID = pbp.GameID
			and abc.Eventnum = pbp.EventNum
			and abc.SequenceNumber = LEN(b.PitchSequence)
	Where left(pbp.pitchsequence, len(b.pitchsequence) -1) = Left(b.PitchSequence, len(b.Pitchsequence) -1)
	and left(pbp.pitchsequence, 1) = Left(b.PitchSequence, 1)
	and NonBatterEventNum is null

--End
--Select b.GameID, b.EventNum, b.pitchsequence, b.inning, b.batter, b.eventtype,  pbp.PitchSequence, pbp.Batter, pbp.inning, pbp.EventNum, abc.*
--  FROM #nbevents b
--	join [Retrosheet].[stage].[PlayByPlay] pbp
--		on b.GameID = pbp.GameID
--		and b.EventNum between pbp.EventNum - 3 and pbp.EventNum
--		and (b.batter = pbp.Batter or b.Outs = pbp.Outs)
--		and b.Inning = pbp.Inning
--	join work.ActionByCount abc
--		on abc.GameID = pbp.GameID
--		and abc.Eventnum = pbp.EventNum
--		and abc.SequenceNumber = LEN(b.PitchSequence)
--Where left(pbp.pitchsequence, len(b.pitchsequence) -1) = Left(b.PitchSequence, len(b.Pitchsequence) -1)
--and left(pbp.pitchsequence, 1) = Left(b.PitchSequence, 1)
--and NonBatterEventNum is null