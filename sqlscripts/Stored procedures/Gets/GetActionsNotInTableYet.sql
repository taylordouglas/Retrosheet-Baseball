Select pitch.[GameId]
,pitch.[EventNum]
,pitch.[SequenceNumber]
,[Pitch]
, pt.*
, maxseq
from stage.PitchByPitch pitch
	left join work.ActionByCount abc
	on pitch.GameId = abc.GameID
	and pitch.EventNum = abc.Eventnum
	and pitch.SequenceNumber  = abc.SequenceNumber
	join stage.PitchType pt
		on pitch.Pitch = pt.PitchCode
	join (select Max(sequencenumber) maxseq, Gameid, eventnum from stage.PitchByPitch group by gameid, eventnum) maxs
                                    on pitch.GameId = maxs.GameId
                                    and pitch.EventNum = maxs.EventNum
where abc.Eventnum is null
Order by GameId, Eventnum, SequenceNumber