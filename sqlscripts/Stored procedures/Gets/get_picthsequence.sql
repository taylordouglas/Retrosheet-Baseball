Create Procedure get_pitchsequence

AS

Select play.GameId
, play.EventNum
, ISNULL(PitchSequence, 'Z') PitchSequence
From stage.PlayByPlay play
    left join stage.PitchByPitch act
        on play.gameid = act.GameId
        and play.EventNum = act.EventNum
Where 
(BatterEventFlag = 'T'
Or (BatterEventFlag = 'f'
and (outs = 2 and outsonplay = 1) or (outs = 1 and outsonplay = 2) or (outs = 0 and outsonplay = 3))
Or ((HomeScore = VisitorScore 
and (RunnerOn1stDest >= 4
or RunnerOn2ndDest >= 4
or RunnerOn3rdDest >= 4
or batterdest >= 4) 
and inning >= 9 
and BattingTeam = 1
and BatterEventFlag = 'F')))
and act.EventNum is null
Order by GameId, EventNum

Go