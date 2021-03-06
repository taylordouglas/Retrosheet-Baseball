Use Retrosheet
go

  Update work.ActionByCount
  Set isFinalAction = 1
  from work.ActionByCount abc
	join (Select gameid
				, Eventnum
				, MAX(SequenceNumber) maxseq
			from work.ActionByCount
			Group By GameID
					, Eventnum) sub
		on abc.GameID = sub.GameID
		and abc.eventnum = sub.Eventnum
		and abc.SequenceNumber = sub.maxseq
	where abc.isfinalAction is null
  
  
  
  
  
  
 -- Select abc.*
 -- from work.ActionByCount abc
	--join (Select gameid
	--			, Eventnum
	--			, MAX(SequenceNumber) maxseq
	--		from work.ActionByCount
	--		Group By GameID
	--				, Eventnum) sub
	--	on abc.GameID = sub.GameID
	--	and abc.eventnum = sub.Eventnum
	--	and abc.SequenceNumber = sub.maxseq
	--order by GameID, Eventnum