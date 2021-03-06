/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Concat(Cast(PrePitchBalls as varchar(5)), '-',Cast(PrePitchStrikes as varchar(5))) as PrePitchCount  
	, PrePitchBalls
	, PrePitchStrikes
	, SUM(Case when pt.PitchFlag = 1 or IsFinalAction = 1 then 1 else 0 end) as CountTimes
	, SUM(cast(IsAttemptedSteal as int)) as StealAttempts
	, SUM(cast(IsWildPitch as int)) as WildPitches
	, SUM(cast(IsPassedBall as int)) as PassedBalls
	, SUM(cast(ISBlocked as int)) as BlockedBalls
--	, SUM(cast(IsCatcherPickoff as int)) as CatcherPicks
	, SUM(Case when PostPitchStrikes > PrePitchStrikes then 1 else 0 end) as StrikesThrown
	, SUM(Case when PostPitchBalls > PrePitchBalls then 1 else 0 end) as BallsThrown
	, SUM(cast(IsFinalAction as int)) as LastPitchofAB
  FROM [Retrosheet].[dbo].[ActionFact] af
	left join stage.PitchType pt
		on af.ActionCode = pt.PitchCode	
  Group by PrePitchBalls
	, PrePitchStrikes
  Order by PrePitchBalls
	, PrePitchStrikes