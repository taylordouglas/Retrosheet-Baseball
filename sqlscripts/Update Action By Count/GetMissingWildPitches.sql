Use Retrosheet
go

With WildPitches as
(
Select *
From stage.PlayByPlay pbp
where WildPitchFlag = 'T'
  and BatterEventFlag = 'F'
  and OutsOnPlay + Outs < 3
)
, MissingWp as
(
Select wp.*
from WildPitches wp
left join work.ActionByCount abc
	on abc.GameID = wp.GameID
	and abc.Eventnum = wp.EventNum + 1
	and abc.SequenceNumber = LEN(wp.PitchSequence)
WHere PitchCode != SUBSTRING(PitchSequence, SequenceNumber, 1)
or abc.GameID is null 
)


Select *
From MissingWp mp
left join stage.PlayByPlay pbp
	on mp.GameID = pbp.GameID
	and mp.EventNum = pbp.EventNum - 2
left join work.ActionByCount abc
	on pbp.GameID = abc.GameID
	and pbp.EventNum = abc.Eventnum
	and pbp.Batter = mp.Batter
	and pbp.Inning = mp.Inning
	and abc.SequenceNumber = len(mp.PitchSequence)
where abc.PitchCode != SUBSTRING(mp.PitchSequence, SequenceNumber, 1)
or abc.GameID is null