--/****** Script for SelectTopNRows command from SSMS  ******/
--Update work.ActionByCount
--Set IsWildPitch = 1

Select *
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
  left join work.ActionByCount ac
	on pbp.GameID = ac.GameID
	and pbp.EventNum = ac.Eventnum
  where WildPitchFlag = 'T'
  and EventText like 'K%'
  and SequenceNumber = (Select Max(SequenceNumber) from work.ActionByCount sub where sub.GameID = ac.GameID
																						and sub.Eventnum = ac.Eventnum)