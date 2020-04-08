/****** Script for SelectTopNRows command from SSMS  ******/
	Update abc
	Set IsCatcherPickoff = 1
  FROM [Retrosheet].[work].[ActionByCount] abc
	join work.ActionByCount prev
		on abc.GameID = prev.GameID
		and abc.Eventnum = prev.Eventnum
		and abc.SequenceNumber = prev.SequenceNumber + 1
		and prev.PitchCode = '+'
	Where abc.PitchCode in ('1','2', '3')

