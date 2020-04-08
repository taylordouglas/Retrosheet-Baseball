Create Procedure update_passedball_main

AS

with PassBalls as
(
 SELECT pbp.*
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
	left join work.ActionByCount abc
		on abc.GameID = pbp.GameID
		and abc.NonBatterEventNum = pbp.EventNum
  where EventType =10
  and abc.GameID is null
)

  Update work.ActionByCount
  set ispassedball = 1, NonBatterEventNum = pb.EventNum
  FROM PassBalls pb
	join [Retrosheet].[stage].[PlayByPlay] pbp
		on pb.GameID = pbp.GameID
		and pb.EventNum between pbp.EventNum - 3 and pbp.EventNum
		and pb.batter = pbp.Batter
		and pb.Inning = pbp.Inning
	join work.ActionByCount abc
		on abc.GameID = pbp.GameID
		and abc.Eventnum = pbp.EventNum
		and abc.SequenceNumber = LEN(pb.PitchSequence)
		and abc.PitchCode = SUBSTRING(pb.PitchSequence, SequenceNumber, 1)
		--and left(pbp.pitchsequence, len(pb.pitchsequence)) = pb.PitchSequence
  Where (ISNULL(ispassedball,0) != 1 or NonBatterEventNum is null)

  Go

 