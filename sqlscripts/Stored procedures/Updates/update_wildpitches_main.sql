Create Procedure update_wildpitches_main
	
As

With WildPitches as
(
Select *
From stage.PlayByPlay pbp
where WildPitchFlag = 'T'
or EventType = 9
)

, MissingWp as
(
Select wp.*
from WildPitches wp
left join work.ActionByCount abc
	on abc.GameID = wp.GameID
	and abc.NonBatterEventNum = wp.EventNum
WHere abc.GameID is null 
)


Update work.ActionByCount
set IsWildPitch = 1, NonBatterEventNum = mp.EventNum
From MissingWp mp
join stage.PlayByPlay pbp
	on mp.GameID = pbp.GameID
	and mp.EventNum between pbp.EventNum - 3 and pbp.EventNum
	and (pbp.Batter = mp.Batter)
	and pbp.Inning = mp.Inning
join work.ActionByCount abc
	on pbp.GameID = abc.GameID
	and pbp.EventNum = abc.Eventnum
	and abc.SequenceNumber = len(mp.PitchSequence)
	and abc.PitchCode = SUBSTRING(mp.PitchSequence, SequenceNumber, 1)
where ISNULL(iswildpitch, 0) != 1 or abc.NonBatterEventNum is null

GO