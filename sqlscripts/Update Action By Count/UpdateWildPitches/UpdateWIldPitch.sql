Use Retrosheet
go

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


--Update work.ActionByCount
--set IsWildPitch = 1, NonBatterEventNum = mp.EventNum
Select *
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
	--and left(pbp.pitchsequence, len(mp.pitchsequence)) = mp.PitchSequence
where ISNULL(iswildpitch, 0) != 1 or abc.NonBatterEventNum is null


--and (abc.IsWildPitch != 1 or abc.NonBatterEventNum is null)


--Select count(*) from work.ActionByCount
--where IsWildPitch = 1

--select count(*) from stage.PlayByPlay
--where WildPitchFlag = 'T'


--Select * 
--from WildPitches pbp
--left join work.ActionByCount abc
--	on pbp.GameID = abc.GameID
--	and pbp.EventNum = abc.Eventnum - 1
--	and abc.SequenceNumber = LEN(PitchSequence)
--  where WildPitchFlag = 'T'
--  and BatterEventFlag = 'F'
--  and OutsOnPlay + Outs < 3
--  --and PitchCode = SUBSTRING(PitchSequence, SequenceNumber, 1)
--  and (abc.GameID is null Or PitchCode != SUBSTRING(PitchSequence, SequenceNumber, 1))
--  and Outs = 2
  


--Select pbp.*, wp.PitchSequence, wp.PitchSequence, wp.GameID, wp.EventNum
--from WildPitches wp
--	left join stage.PlayByPlay pbp
--	on wp.GameID = pbp.GameID
--		and pbp.EventNum > wp.EventNum
--		and pbp.BatterEventFlag = 'T' or pbp.OutsOnPlay + pbp.Outs = 3)
--		and pbp.Inning = wp.Inning
--		and pbp.Batter = wp.Batter
--	where pbp.GameID is null

	


  
  --order by pbp.GameID, pbp.Eventnum, SequenceNumber


  --select * from work.ActionByCount
  --where GameID = 'TOR201609110'
  --and Eventnum in (90,91,92)


  --14077
  --13781 = 296

  --select * 
  --from work.ActionByCount
  --where GameID = 'ANA201004240'
  --and Eventnum >= 39

  --select * 
  --from stage.PlayByPlay
  --where GameID = 'ANA201004240'
  --and Eventnum >= 39
  --Order by EventNum
