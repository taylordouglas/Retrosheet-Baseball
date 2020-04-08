/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [GameID]
      ,[Eventnum]
      ,[SequenceNumber]
      ,[PitchCode]
      ,[PrePitchBalls]
      ,[PrePitchStrikes]
      ,[IsAttemptedSteal]
      ,[IsWildPitch]
      ,[IsBlocked]
      ,[IsCatcherPickoff]
      ,[PostPitchBalls]
      ,[PostPitchStrikes]
	  from work.ActionByCount



 