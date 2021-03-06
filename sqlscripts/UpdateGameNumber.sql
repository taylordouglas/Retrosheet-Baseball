Create Procedure update_stage_game_gamenumber

as

drop table if exists #DistinctTeams

CREATE TABLE #DISTINCTTEAMS
(
	GAMEID VARCHAR(25),
	GAMEYEAR INT,
	TEAM VARCHAR(4),
	GAMENUMBER SMALLINT,

)

 

Declare @TEAM VARCHAR(4)
Declare @YEAR INT
  
DECLARE db_cursor CURSOR FOR
Select Distinct HomeTeam
From stage.Game


OPEN DB_CURSOR
FETCH NEXT FROM DB_CURSOR INTO @TEAM
	
WHILE @@FETCH_STATUS = 0
BEGIN
	
	INSERT INTO #DISTINCTTEAMS

	SELECT GAMEID
		, YEAR(GAMEDATE) AS GAMEYEAR
		, CASE 
			WHEN HomeTeam = @TEAM THEN HomeTeam
			WHEN AwayTeam = @TEAM THEN AwayTeam
			END AS TEAM
		, ROW_NUMBER() OVER(PARTITION BY YEAR(GAMEDATE) ORDER BY GAMEDATE) AS GAMENUMBER
	FROM stage.Game
	WHERE HomeTeam = @TEAM
	OR AwayTeam = @TEAM

	FETCH NEXT FROM db_cursor INTO @Team 

END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

Update stage.Game
set HomeGameNumber = Home.GAMENUMBER
FROM stage.GAME G
	LEFT JOIN #DISTINCTTEAMS home
		ON G.GameId = home.GAMEID
		AND G.HomeTeam = home.TEAM
	LEFT JOIN #DISTINCTTEAMS away
		ON G.GameId = away.GAMEID
		AND G.AWAYTeam = away.TEAM
where g.homegamenumber is null

Update stage.Game
set AwayGameNumber = away.GAMENUMBER
FROM stage.GAME G
	LEFT JOIN #DISTINCTTEAMS away
		ON G.GameId = away.GAMEID
		AND G.AWAYTeam = away.TEAM
where g.awaygamenumber is null

Go