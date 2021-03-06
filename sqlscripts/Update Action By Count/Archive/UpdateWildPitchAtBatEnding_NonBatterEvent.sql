Use Retrosheet
go

	Update work.ActionByCount
	set IsWildPitch = 1, NonBatterEventNum = pbp.EventNum
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
  and (abc.IsWildPitch != 1 or abc.NonBatterEventNum is null)



