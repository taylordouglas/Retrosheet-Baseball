/****** Script for SelectTopNRows command from SSMS  ******/
--Unmapped NonBatterEvents


Select *
From 
(SELECT *
  FROM [Retrosheet].[stage].[PlayByPlay]
  where BatterEventFlag = 'F') pbp
  left join work.ActionByCount abc
	on abc.GameID = pbp.GameID
	and abc.NonBatterEventNum = pbp.EventNum
where abc.gameid is null