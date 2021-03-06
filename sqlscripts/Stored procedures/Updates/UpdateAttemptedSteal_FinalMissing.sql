Create Procedure update_attemptedsteal_altpitchcode

As

With missingSteal as

(
SELECT pbp.*
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
	left join work.ActionByCount abc
		on abc.GameID = pbp.GameID
		and abc.NonBatterEventNum = pbp.EventNum
  where EventType in (4,6)
  and abc.GameID is null
)

Update work.ActionByCount
set IsAttemptedSteal = 1, NonBatterEventNum = ms.EventNum
From MissingSteal ms
join stage.PlayByPlay pbp
	on ms.GameID = pbp.GameID
	and ms.EventNum between pbp.EventNum - 3 and pbp.EventNum
	and pbp.Batter = ms.Batter
	and pbp.Inning = ms.Inning
join work.ActionByCount abc
	on pbp.GameID = abc.GameID
	and pbp.EventNum = abc.Eventnum
	and abc.SequenceNumber = len(ms.PitchSequence)
where (NonBatterEventNum is null)

Go