/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [Retrosheet].[stage].[PlayByPlay] pbp
	left join work.ActionByCount abc
		on pbp.GameID = abc.GameID
		and pbp.EventNum = abc.NonBatterEventNum
  where WildPitchFlag = 'T'
  and abc.NonBatterEventNum is null
  