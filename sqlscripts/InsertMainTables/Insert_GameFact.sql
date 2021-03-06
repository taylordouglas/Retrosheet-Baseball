Create Procedure insert_gamefact
	@startyear int = null,
	@endyear int = null

AS

Insert Into GameFact

Select d.DateKey														as GameDateKey
	, d.Year															as YearID
	, sg.WinningTeam													as WinningTeamID
	, sg.HomeTeam														as HomeTeamID
	, sg.HomeGameNumber													as HomeGameNumber
	, hsp.PersonKey														as HomeStartingPitcherKey
	, sg.HomeFinalScore													as HomeFinalScore
	, sg.AwayTeam														as AwayTeamID 
	, sg.AwayGameNumber													as AwayGameNumber
	, asp.PersonKey														as AwayStartingPitcher
	, sg.AwayFinalScore													as AwayFinalScore
	, sg.FinalInning													as FinalInning
	, fb.PersonKey														as FinalBatterKey
	, fp.PersonKey														as FinalPitcherKey
	, Case when sg.FinalBattingTeam = 'Away' then 0 else 1 end			as FinalBattingTeam
	, wp.PersonKey														as WinningPitcherKey
	, lp.PersonKey														as LosingPitcherKey
	, cp.PersonKey														as ClosingPitcherKey
	, sg.IsWalkOffHomeRun												as IsWalkOffHomeRun
	, sg.IsWalkOff														as IsWalkOff
	, sg.IsExtraInningGame												as IsExtraInningGame
	, sg.IsDoubleHeader													as IsDoubleHeader
	, sg.GameOfDoubleHeader												as GameOfDoubleHeader
	, sg.IsShortenedGame												as IsShortenedGame
	, sg.GameId															as Retro_GameId
	, NULL																as IsPostSeason
From stage.Game sg
	join Date_dim d
		on sg.GameDate = d.Date
	left join Person hsp
		on sg.HomeStartingPitcher = hsp.Retro_PersonID
	left join Person asp
		on sg.AwayStartingPitcher = asp.Retro_PersonID
	left join Person fb
		on sg.FinalBatter = fb.Retro_PersonID
	left join Person fp
		on sg.FinalPitcher = fp.Retro_PersonID
	left join Person wp
		on sg.WinningPitcher = wp.Retro_PersonID
	left join Person lp
		on sg.LosingPitcher = lp.Retro_PersonID
	left join Person cp
		on sg.ClosingPitcher = cp.Retro_PersonID
	left join GameFact g
		on sg.GameId = g.Retro_GameID
Where g.Retro_GameID is null
and (@startyear is null or @startyear >= d.Year)
 and (@endyear is null or @endyear <= d.Year)

 GO