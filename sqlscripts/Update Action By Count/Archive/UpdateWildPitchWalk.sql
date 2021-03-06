/****** Script for SelectTopNRows command from SSMS  ******/
  Update work.ActionByCount
  set IsWildPitch = 1, NonBatterEventNum = pbp.EventNum
  FROM work.ActionByCount abc
  join (Select Max(SequenceNumber) Maxseq, GameID, Eventnum from work.ActionByCount sub group by GameID, Eventnum) ac
	on abc.GameID = ac.GameID
	and abc.EventNum = ac.Eventnum
	and abc.SequenceNumber = ac.Maxseq
  join stage.PlayByPlay pbp
	on ac.GameID = pbp.GameID
	and ac.Eventnum = pbp.EventNum
  where WildPitchFlag = 'T'
  and BatterEventFlag = 'T'
  and (abc.IsWildPitch is null or abc.NonBatterEventNum is null)

 



  --15429
  --14393