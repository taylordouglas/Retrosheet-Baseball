Create Procedure insert_ActionFact
	@id_start INT = 1,
	@id_end int = 100000,
	@batchSize int = 100000,
	@Complete int = NULL
AS

If @Complete is NULL
	Begin
		Set @Complete = (Select Count(*) from PlayFact)
	END

WHILE @id_start < @Complete
	Begin

	Insert Into ActionFact

		Select  pf.PlayKey												as PlayKey
			  , pf.GameKey
			  , abc.Eventnum
			  , abc.SequenceNumber
			  , nonb.PlayKey											as NonBatterPlayKey
			  , abc.PitchCode											as ActionCode
			  , pt.Description											as ActionDescription
			  , abc.PrePitchBalls
			  , abc.PrePitchStrikes
			  , abc.IsAttemptedSteal
			  , abc.IsWildPitch
			  , abc.IsPassedBall
			  , abc.IsBalk
			  , abc.IsBlocked
			  , abc.IsCatcherPickoff
			  , abc.PostPitchBalls
			  , abc.PostPitchStrikes
			  , abc.isFinalAction
		from PlayFact pf
			join GameFact gf
				on pf.GameKey = gf.GameKey
			join work.ActionByCount abc
				on abc.GameID = gf.Retro_GameID
				and abc.Eventnum = pf.EventNum
			left join stage.PitchType pt
				on abc.PitchCode = pt.PitchCode
			left join PlayFact nonb
				on pf.gamekey = nonb.GameKey
				and nonb.EventNum = abc.NonBatterEventNum
			left join ActionFact af
				on pf.PlayKey = af.PlayKey
				and abc.SequenceNumber = af.SequenceNum
		Where pf.PlayKey between @id_start and @id_end
		and af.playkey is null
		Order By pf.PlayKey, abc.SequenceNumber
		
		
		
		set @id_start = @id_start + @batchsize
		set @id_end = @id_end + @batchSize

	END

GO