Create Procedure insert_playfact
	@startyear int = null,
	@endyear int = null

AS

Insert Into PlayFact

SELECT 
		gf.GameKey																as GameKey
	  , gf.GameDateKey															as GameDateKey
	  , gf.YearID																as YearID
	  , pbp.EventNum															as EventNum
	  , Case when pbp.NewGameFlag = 'T' then 1 else 0 end						as IsNewGame
	  , Case when pbp.EndGameFlag = 'T' then 1 else 0 end						as IsEndOfGame
	  , gf.HomeTeamID															as HomeTeamId
	  , gf.AwayTeamID															as AwayTeamId
	  , pbp.Inning																as Inning
	  , pbp.BattingTeam															as BattingTeam
	  , pbp.Outs																as OutsPrior
	  , pbp.HomeScore															as HomeScorePrior
	  , pbp.VisitorScore														as AwayScorePrior
	  , pbp.Balls																as Balls
	  , pbp.Strikes																as Strikes
	  , bat.PersonKey															as BatterKey
	  , pbp.BatterHand															as BatterHand
	  , pbp.DefensivePosition													as BatterDefensivePosition
	  , pbp.PositionOfBatterRemovedForPinchHitter								as BatterRemovedForPinchHitDefensivePosition
	  , pbp.LineupPosition														as BatterLineupPosition
	  , pit.PersonKey															as PitcherKey
	  , pbp.PitcherHand															as PitcherHand
	  , cat.PersonKey															as CatcherKey
	  , b1.PersonKey															as FirstBasemanKey
	  , b2.PersonKey															as SecondBasemanKey
	  , b3.PersonKey															as ThirdBasemanKey
	  , ss.PersonKey															as ShortstopKey
	  , lf.PersonKey															as LeftFielderKey
	  , cf.PersonKey															as CenterFielderKey
	  , rf.PersonKey															as RightFielderKey
	  , run1.PersonKey															as FirstRunnerKey
	  , run2.PersonKey															as SecondRunnerKey
	  , run3.PersonKey															as ThirdRunnerKey
	  , pitrun1.PersonKey														as ResponsiblePitcherFirstKey
	  , pitrun2.PersonKey														as ResponsiblePitcherSecondKey
	  , pitrun3.PersonKey														as ResponsiblePitcherThirdKey
	  , Case when pbp.PinchHitFlag = 'T' then 1 else 0 end						as IsPinchHit
	  , batrem.PersonKey														as BatterRemovedForPinchHitKey
	  , Case when pbp.PinchRunnerOn1st = 'T' then 1 else 0 end					as IsPinchRunnerOnFirst
	  , runrem1.PersonKey														as RunnerRemovedForPinchRunnerOnFirstKey
	  , Case when pbp.PinchRunnerOn2nd = 'T' then 1 else 0 end					as IsPinchRunnerOn2nd
	  , runrem2.PersonKey														as RunnerRemovedForPinchRunnerOnSecondKey
	  , Case when pbp.PinchRunnerOn3rd = 'T' then 1 else 0 end					as IsPinchRunnerOnFirst
	  , runrem3.PersonKey														as RunnerRemovedForPinchRunnerOnThirdKey
	  , Case when LeadoffFlag = 'T' then 1 else 0 end							as IsLeadoff
	  , pbp.EventType															as EventTypeKey
	  , Case when BatterEventFlag = 'T' then 1 else 0 end						as IsBatterEvent
	  , Case when AbFlag = 'T' then 1 else 0 end								as IsAB
	  , pbp.HitValue															as TotalBases
	  , Case when pbp.SHFlag = 'T' or pbp.SFFlag = 'T' then 1 else 0 end		as IsSacrifice
	  , pbp.OutsOnPlay															as OutsOnPlay
	  , pbp.Outs + pbp.OutsOnPlay												as OutsAfter
	  , pbp.RBIOnPlay															as RBIOnPlay
	  , pbp.BatterDest															as BatterDest
	  , pbp.RunnerOn1stDest														as RunnerOnFirstDest
	  , pbp.RunnerOn2ndDest														as RunnerOnSecondDest
	  , pbp.RunnerOn3rdDest														as RunnerOnThirdDest
	  , pbp.batterdest / 4 + pbp.RunnerOn1stDest / 4 
	    + pbp.RunnerOn2ndDest / 4 + pbp.RunnerOn3rdDest / 4						as RunScored
	  , Case when pbp.BattingTeam = 1 then pbp.HomeScore + pbp.RunsScored
		else pbp.HomeScore end													as HomeScoreAfter
	  , Case when pbp.BattingTeam = 0 then pbp.VisitorScore + pbp.RunsScored
		else pbp.VisitorScore end												as AwayScoreAfter
	  , Case when pbp.PassedBallFlag = 'T' then 1 else 0 end					as IsPassedBall
	  , Case when pbp.WildPitchFlag = 'T' then 1 else 0 end						as IsWildPitch
	  , pbp.FieldedBy															as FieldedBy
	  , pbp.BattedBallType														as BattedBallType
	  , Case when pbp.BuntFlag = 'T' then 1 else 0 end							as IsBunt
	  , Case when pbp.FoulFlag = 'T' then 1 else 0 end							as IsFoul
	  , po1.PersonKey															as FirstPOFielderKey
	  , pbp.FielderWithFirstPutout												as FirstPOFielderPosition
	  , po2.PersonKey															as SecondPOFielderKey
	  , pbp.FielderWithSecondPutout												as SecondPOFielderPosition
	  , po3.PersonKey															as ThirdPOFielderKey
	  , pbp.FielderWithThirdPutout												as ThirdPOFielderPosition
	  , as1.PersonKey															as FirstAssistFielderKey
	  , pbp.FielderWithFirstAssist												as FirstAssisterFielderPosition
	  , as2.PersonKey															as SecondAssistFielderKey
	  , pbp.FielderWithSecondAssist												as SecondAssisterFielderPosition
	  , as3.PersonKey															as ThirdAssistFielderKey
	  , pbp.FielderWithThirdAssist												as ThirdAssisterFielderPosition
	  , as4.PersonKey															as FourthAssistFielderKey
	  , pbp.FielderWithFourthAssist												as FourthAssisterFielderPosition
	  , as5.PersonKey															as FifthAssistFielderKey
	  , pbp.FielderWithFifthAssist												as FifthAssisterFielderPosition
	  , pbp.NumErrors															as NumErrors
	  , e1.PersonKey															as FirstErrorPlayerKey
	  , pbp.FirstErrorPlayer													as FirstErrorPlayerPosition
	  , pbp.FirstErrorType														as FirstErrorType
	  , e2.PersonKey															as SecondErrorPlayerKey
	  , pbp.SecondErrorPlayer													as SecondErrorPlayerPosition
	  , pbp.SecondErrorType														as SecondErrorType
	  , e3.PersonKey															as ThirdErrorPlayerKey
	  , pbp.ThirdErrorPlayer													as ThirdErrorPlayerPosition
	  , pbp.ThirdErrorType														as ThirdErrorType
	  , Case when SBForRunnerOn1stFlag = 'T' then 1 else 0 end					as IsSBRunnerOn1st
	  , Case when SBForRunnerOn2ndFlag = 'T' then 1 else 0 end					as IsSBRunnerOn2nd
	  , Case when SBForRunnerOn3rdFlag = 'T' then 1 else 0 end					as IsSBRunnerOn3rd
	  , Case when CSForRunnerOn1stFlag = 'T' then 1 else 0 end					as IsCSRunnerOn1st
	  , Case when CSForRunnerOn2ndFlag = 'T' then 1 else 0 end					as IsCSRunnerOn2nd
	  , Case when CSForRunnerOn3rdFlag = 'T' then 1 else 0 end					as IsCSRunnerOn3rd
	  , Case when POForRunnerOn1stFlag = 'T' then 1 else 0 end					as IsPORunnerOn1st
	  , Case when POForRunnerOn2ndFlag = 'T' then 1 else 0 end					as IsPORunnerOn2nd
	  , Case when POForRunnerOn3rdFlag = 'T' then 1 else 0 end					as IsPORunnerOn3rd
	  , Case when pbp.BatterEventFlag = 'F' 
			and abc.NonBatterEventNum is null then 1
		else NULL end															as IsUnmappedNonBatterEvent
  FROM (Select *
		, batterdest / 4 + RunnerOn1stDest / 4 
	    + RunnerOn2ndDest / 4 + RunnerOn3rdDest / 4 as RunsScored
		, Case FielderWithFirstPutout
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithFirstPutoutID
		, Case FielderWithSecondPutout
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithSecondPutoutID
		 , Case FielderWithThirdPutout
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithThirdPutoutID
		 , Case FielderWithFirstAssist
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithFirstAssistID
		 , Case FielderWithSecondAssist
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithSecondAssistID
		 , Case FielderWithThirdAssist
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithThirdAssistID
		 , Case FielderWithFourthAssist
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithFourthAssistID
		 , Case FielderWithFifthAssist
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FielderWithFifthAssistID
		  , Case FirstErrorPlayer
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as FirstErrorPlayerID
		  , Case SecondErrorPlayer
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as SecondErrorPlayerID
		  , Case ThirdErrorPlayer
			when 1 then Pitcher
			when 2 then Catcher
			when 3 then FirstBase
			when 4 then SecondBase
			when 5 then ThirdBase
			when 6 then Shortstop
			when 7 then LeftField
			when 8 then CenterField
			when 9 then RightField
			else null
			end as ThirdErrorPlayerID
		From [Retrosheet].[stage].[PlayByPlay]) pbp
	join GameFact gf
		on pbp.GameID = gf.Retro_GameID
	join Person bat
		on pbp.Batter = bat.Retro_PersonID
	join Person pit
		on pbp.Pitcher = pit.Retro_PersonID
	join Person cat
		on pbp.Catcher = cat.Retro_PersonID
	join Person b1
		on pbp.FirstBase = b1.Retro_PersonID
	join Person b2
		on pbp.SecondBase = b2.Retro_PersonID
	join Person b3
		on pbp.ThirdBase = b3.Retro_PersonID
	join Person ss
		on pbp.Shortstop = ss.Retro_PersonID
	join Person lf
		on pbp.LeftField = lf.Retro_PersonID
	join Person cf
		on pbp.CenterField = cf.Retro_PersonID
	join Person rf
		on pbp.RightField = rf.Retro_PersonID
	left join Person run1
		on pbp.FirstRunner = run1.Retro_PersonID
	left join Person run2
		on pbp.SecondRunner = run2.Retro_PersonID
	left join Person run3
		on pbp.ThirdRunner = run3.Retro_PersonID
	left join Person pitrun1
		on pbp.ResponsiblePitcherForRunnerOn1st = pitrun1.Retro_PersonID
	left join Person pitrun2
		on pbp.ResponsiblePitcherForRunnerOn2nd = pitrun2.Retro_PersonID
	left join Person pitrun3
		on pbp.ResponsiblePitcherForRunnerOn3rd = pitrun3.Retro_PersonID
	left join Person batrem
		on pbp.BatterRemovedForPinchHitter = batrem.Retro_PersonID
	left join Person runrem1
		on pbp.RunnerRemovedForPinchRunnerOn1st = runrem1.Retro_PersonID
	left join Person runrem2
		on pbp.RunnerRemovedForPinchRunnerOn2nd = runrem2.Retro_PersonID
	left join Person runrem3
		on pbp.RunnerRemovedForPinchRunnerOn3rd = runrem3.Retro_PersonID
	left join Person po1
		on pbp.FielderWithFirstPutoutID = po1.Retro_PersonID
	left join Person po2
		on pbp.FielderWithSecondPutoutID = po2.Retro_PersonID
	left join Person po3
		on pbp.FielderWithThirdPutoutID = po3.Retro_PersonID
	left join Person as1
		on pbp.FielderWithFirstAssistID = as1.Retro_PersonID
	left join Person as2
		on pbp.FielderWithSecondAssistID = as2.Retro_PersonID
	left join Person as3
		on pbp.FielderWithThirdAssistID = as3.Retro_PersonID
	left join Person as4
		on pbp.FielderWithFourthAssistID = as4.Retro_PersonID
	left join Person as5
		on pbp.FielderWithFifthAssistID = as5.Retro_PersonID
	left join Person e1
		on pbp.FirstErrorPlayerID = e1.Retro_PersonID
	left join Person e2
		on pbp.SecondErrorPlayerID = e2.Retro_PersonID
	left join Person e3
		on pbp.ThirdErrorPlayerID = e3.Retro_PersonID
	left join work.ActionByCount abc
		on pbp.GameID = abc.GameId
		and pbp.EventNum = abc.NonBatterEventNum
	Left join PlayFact pf
		on gf.GameKey = pf.GameKey
		and pbp.EventNum = pf.EventNum
  Where pf.EventNum is null
  and (@startyear is null or @startyear >= Year(gf.GameDateKey))
  and (@endyear is null or @endyear <= Year(gf.GameDateKey))
  Order By GameKey, EventNum, YearID

  Go
