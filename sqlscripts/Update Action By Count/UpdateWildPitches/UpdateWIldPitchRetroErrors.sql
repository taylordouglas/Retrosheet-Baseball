/****** Script for SelectTopNRows command from SSMS  ******/
Use Retrosheet
go

Update work.ActionByCount
set IsWildPitch = 1, NonBatterEventNum = 90
from work.ActionByCount
where GameID = 'TOR201609110'
and Eventnum = 91
and SequenceNumber = 4

Update work.ActionByCount
set IsWildPitch = 1, NonBatterEventNum = 15
from work.ActionByCount
where GameID = 'HOU201809040'
and Eventnum = 16
and SequenceNumber = 8

Update work.ActionByCount
set IsWildPitch = 1, NonBatterEventNum = 80
from work.ActionByCount
where GameID = 'SLN201105020'
and Eventnum = 81
and SequenceNumber = 2


--Select * from stage.PlayByPlay
--where (GameID = 'TOR201609110'
--and Eventnum between 90 and 92)
--Or (GameID = 'HOU201809040'
--and Eventnum Between 15 and 18)
--Or (GameID = 'SLN201105020'
--and Eventnum between 80 and 82)
 