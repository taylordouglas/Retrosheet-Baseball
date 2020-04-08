Use Retrosheet 
go

--Null Sequence
Update work.ActionByCount
set isbalk = 1, NonBatterEventNum = 77
where GameID = 'MIN201709120'
	and Eventnum = 78
	and SequenceNumber = 1


--PinchHitter
Update work.ActionByCount
set isbalk = 1, NonBatterEventNum = 77
where GameID = 'NYN201106020'
	and Eventnum = 79
	and SequenceNumber = 5


--Changed Sequence
Update work.ActionByCount
set isbalk = 1, NonBatterEventNum = 17
where GameID = 'SLN201208040'
	and Eventnum = 18
	and SequenceNumber = 5