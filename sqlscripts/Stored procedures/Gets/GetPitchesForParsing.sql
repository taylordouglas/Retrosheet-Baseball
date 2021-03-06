/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) pbp.[GameId]
      ,pbp.[EventNum]
      ,[SequenceNumber]
      ,[Pitch]
	  , pt.*
  FROM [Retrosheet].[stage].[PitchByPitch] pbp
	join stage.PitchType pt
		on pbp.pitch = pt.PitchCode
	where pitchcode = 'L'
	and SequenceNumber = (Select Max(SequenceNumber) 
							From stage.PitchByPitch sub
							where pbp.GameId = sub.GameId
								and pbp.EventNum = sub.EventNum)
	order by pbp.GameId

	select *
	from stage.PitchByPitch
	where gameid = 'ANA201206020'
	and EventNum = 55

		  --, WildPitchFlag
	  --, len(pitchsequence) as WildPitchNumber

		--left join stage.PlayByPlay play
	--	on pbp.GameId = play.GameID
	--	and pbp.EventNum - 1 = play.EventNum
	--	and play.WildPitchFlag = 'T'
	--where WildPitchFlag = 'T'
	/*
	Iterate through gameid and eventnumber
	iterate through sequence for each event


	*/