Create procedure insert_gameteam_summary

AS

Drop table if exists #TempTeamGame

Create Table #TempTeamGame

(
	GameKey					int			not null		,
	GameDateKey				int			not null		,
	TeamID					char(3)		not null		,
	YearID					smallint	not null		,
	TeamGameNumber			tinyint		not null		,
	TeamStartingPitcherKey	int							,
	IsHome					bit							,
	TeamScore				smallint					,
	IsWin					bit							,
	IsDoubleHeader			bit							,
	IsShortenedGame			bit							,
)

DECLARE @game int --Game 
	, @gamedatekey int
	, @year smallint
	, @hometeam char(3) -- HomeTeam for Game 
	, @HomeScore smallint -- 
	, @homegamenumber tinyint
	, @HomeSP int
	, @awayteam char(3)
	, @AwayScore smallint
	, @awaygamenumber tinyint
	, @AwaySP int
	, @homewin bit
	, @awaywin bit
	, @DH bit
	, @short int


DECLARE db_cursor CURSOR FOR 
SELECT  GameKey
	, GameDateKey
	, YearID
	, HomeTeamID
	, HomeFinalScore
	, HomeGameNumber
	, HomeStartingPitcherKey
	, AwayTeamID
	, AwayFinalScore
	, AwayGameNumber
	, AwayStartingPitcherKey
	, Case when WinningTeamID = HomeTeamID then 1 else 0 end as HomeTeamWin
	, Case when WinningTeamID = AwayTeamID then 1 else 0 end as AwayTeamWin
	, IsDoubleHeader
	, IsShortenedGame
FROM GameFact gf

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @game 
							, @gamedatekey
							, @year 
							, @hometeam 
							, @HomeScore 
							, @homegamenumber 
							, @HomeSP 
							, @awayteam 
							, @AwayScore 
							, @awaygamenumber 
							, @AwaySP 
							, @homewin 
							, @awaywin
							, @DH
							, @short 

WHILE @@FETCH_STATUS = 0  
BEGIN  
      Insert into #TempTeamGame
	  Values(@game, @gamedatekey, @hometeam, @year, @homegamenumber, @HomeSP, NULL, @HomeScore, @homewin, @DH, @short)

	  Insert into #TempTeamGame
	  Values(@game, @gamedatekey, @awayteam, @year, @awaygamenumber, @AwaySP, NULL, @AwayScore, @awaywin, @DH, @short)

      FETCH NEXT FROM db_cursor INTO @game 
							, @gamedatekey
							, @year 
							, @hometeam 
							, @HomeScore 
							, @homegamenumber 
							, @HomeSP 
							, @awayteam 
							, @AwayScore 
							, @awaygamenumber 
							, @AwaySP 
							, @homewin 
							, @awaywin
							, @DH
							, @short 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

Insert Into GameTeam_Summary

Select ttg.GameKey
	, ttg.GameDateKey
	, ttg.TeamID
	, ttg.YearID
	, ttg.TeamGameNumber
	, ttg.TeamStartingPitcherKey
	, Case when ttg.TeamID = gf.HomeTeamID then 1 else 0 end as IsHome
	, ttg.TeamScore
	, ttg.IsWin
	, ttg.IsDoubleHeader
	, ttg.IsShortenedGame
From #TempTeamGame ttg
	join GameFact gf
		on ttg.GameKey = gf.GameKey
	Left Join GameTeam_Summary gts
		on ttg.GameKey = gts.GameKey
		and ttg.TeamID = gts.TeamID
Where gts.Gamekey is null
Order by GameKey, GameDateKey, TeamID

GO