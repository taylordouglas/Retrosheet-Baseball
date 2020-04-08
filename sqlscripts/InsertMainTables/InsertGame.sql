Create Procedure insert_stage_game

As

drop table if exists #games
drop table if exists #finalevent
drop table if exists #homeStarter
drop table if exists #AwayStarter

-- Get Distinct Games in order to calculate dates easier later

Select distinct GameID
	, left(gameid, 3) as HomeTeam
	, VisitingTeam
	, Cast(substring(gameid, 8, 2) as int) as GameMonth
	, Cast(SUBSTRING(gameid, 10, 2) as int) as GameDay
	, Cast(SUBSTRING(GameID, 4, 4) as int) as GameYear
	--, Cast(substring(gameid, 8, 2) + '/' + SUBSTRING(gameid, 10, 2) + '/' + SUBSTRING(GameID, 4, 4) as Date) as GameDate
into #games
from stage.PlayByPlay 
Order by GameYear, GameMonth, GameDay

--get Final event of game to calculate final score

Select fe.gameID
	, FinalEvent
	, Inning
	, HomeScore
	, VisitorScore
	, Case when BatterDest = 4 then 1  else 0 end as BatterScored
	, Case when RunnerOn1stDest = 4 then 1 else 0 end as RunnerOn1Scored
	, Case when RunnerOn2ndDest	= 4 then 1 else 0 end as RunnerOn2Scored
	, Case when RunnerOn3rdDest	= 4 then 1 else 0 end as RunnerOn3Scored
Into #FinalEvent
From (Select GameID
	, Max(eventnum) as FinalEvent
		From stage.PlayByPlay
		Group by GameID) fe
	join stage.PlayByPlay pbp
		on fe.GameID = pbp.GameID
		and fe.FinalEvent = pbp.EventNum

-- get Home Starter

Select gameid
	, pitcher as HomeStartingPitcher
Into #HomeStarter
From stage.PlayByPlay
where EventNum = 1

-- get Away Starter
Select gameid
	, pitcher as AwayStartingPitcher
into #AwayStarter
From Stage.PlayByPlay pbp
Where inning = 1
	and BattingTeam = 1
	and EventNum = (Select Min(Eventnum) from stage.PlayByPlay sub where pbp.GameID = sub.GameID
																		and Inning = 1
																		and BattingTeam = 1)

--Insert Games

Insert into stage.Game
(
	GameId				
	, GameDate			
	, WinningTeam			
	, HomeTeam
	, HomeGameNumber			
	, HomeStartingPitcher	
	, HomeFinalScore		
	, AwayTeam
	, AwayGameNumber			
	, AwayStartingPitcher	
	, AwayFinalScore		
	, FinalInning			
	, FinalBatter			
	, FinalPitcher		
	, FinalBattingTeam			
	, IsWalkOffHomeRun	
	, IsWalkOff			
	, IsExtraInningGame	
	, IsDoubleHeader		
	, GameOfDoubleHeader	
	, IsShortenedGame
	, IsPostSeason		
)

Select g.GameID
	, Cast(CAST(GameMonth as varchar(2)) + '/' + Cast(GameDay as varchar(2)) + '/'
		+ Cast(GameYear as varchar(4)) as Date) as GameDate
	, Case when fe.HomeScore + BatterScored + RunnerOn1Scored + RunnerOn2Scored + RunnerOn3Scored > fe.VisitorScore then g.HomeTeam
	 else g.VisitingTeam end as WinningTeam
	, g.HomeTeam
	, Null
	, hs.HomeStartingPitcher
	, fe.HomeScore + BatterScored + RunnerOn1Scored + RunnerOn2Scored + RunnerOn3Scored as HomeFinalScore
	, g.VisitingTeam
	, Null
	, a.AwayStartingPitcher
	, fe.VisitorScore as VisitorFinalScore
	, fe.Inning as FinalInning
	, Batter as FinalBatter
	, Pitcher as FinalPitcher
	, Case when BattingTeam = 1 then 'Home' else 'Away' End as FinalBattingTeam
	, BatterScored as WalkOffHomeRun
	, Case when BatterScored + RunnerOn1Scored + RunnerOn2Scored + RunnerOn3Scored > 0 then 1 else 0 end as WalkOff
	, Case when fe.Inning > 9 then 1 else 0 End as IsExtraInningGame
	, Case when Right(g.GameID, 1) = '0' then 0 else 1 END as IsDoubleHeader
	, Case when Right(g.GameID, 1) = '0' then Null
		else Cast(right(g.GameID,1) as int) End as GameOfDoubleHeader
	, Case when fe.Inning < 9 then 1 else 0 End as ShortenedGame
	, Null
From #games g
	join #FinalEvent fe
		on g.GameID = fe.GameID
	join stage.PlayByPlay pbp
		on fe.GameID = pbp.GameID
		and fe.FinalEvent = pbp.EventNum
	join #HomeStarter hs
		on g.GameID = hs.GameID
	join #AwayStarter a
		on g.GameID = a.GameID
	left join stage.Game sg
		on g.GameID = sg.gameid
Where sg.gameid is null
Order By GameID

Go