/****** Script for SelectTopNRows command from SSMS  ******/
	Update work.ActionByCount
	set IsWildPitch = 1
  FROM work.ActionByCount abc
  join (Select Max(SequenceNumber) Maxseq, GameID, Eventnum from work.ActionByCount sub group by GameID, Eventnum) ac
	on abc.GameID = ac.GameID
	and abc.EventNum = ac.Eventnum
	and abc.SequenceNumber = ac.Maxseq
  join [stage].[PlayByPlay] pbp
	on pbp.GameID = abc.GameID
	and abc.Eventnum = pbp.EventNum
  where WildPitchFlag = 'T'
  and BatterEventFlag = 'F'

  --select * 
  --from work.ActionByCount
  --where GameID = 'DET201204190'
  --and eventnum in (62,63)
