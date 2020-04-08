Use Retrosheet
go

With GEWildPitches as
(
Select *
From stage.PlayByPlay pbp
where WildPitchFlag = 'T'
  and BatterEventFlag = 'F'
  and OutsOnPlay + Outs < 3
  and ((HomeScore = VisitorScore 
and (RunnerOn1stDest >= 4
or RunnerOn2ndDest >= 4
or RunnerOn3rdDest >= 4
or batterdest >= 4) 
and inning >= 9 
and BattingTeam = 1
and BatterEventFlag = 'F'))
)

--Update work.ActionByCount
--set IsWildPitch = 1

Select *
from GEWildPitches ge
	join work.ActionByCount abc
		on ge.GameID = abc.GameID
		and ge.EventNum = abc.Eventnum
		and abc.SequenceNumber = len(ge.pitchsequence)
WHERE abc.PitchCode = right(ge.PitchSequence, 1)
Order by ge.GameID
--and left(.pitchsequence, len(ge.pitchsequence)) = ge.PitchSequence