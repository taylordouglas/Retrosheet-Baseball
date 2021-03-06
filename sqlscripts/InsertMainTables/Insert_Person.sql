Create Procedure insert_person

AS

Insert into Person 

Select sp.Retro_PersonId
	, sp.Lah_PersonId as Lahman_PersonID
	, sp.BBREF_PersonId
	, sp.PersFirstName
	, sp.PersLastName
	, sp.PersGivenName
	, sp.BirthDateKey
	, sp.PersBirthCountry
	, sp.PersBirthState
	, sp.PersBirthState
	, sp.DeathDateKey
	, sp.PersWeight
	, sp.PersHeight
	, sp.PersBattingHand
	, sp.PersThrowingHand
	, debut.DateKey
	, ret.DateKey
From Stage.Person sp
	left join Date_dim debut
		on sp.PersDebutDate = debut.Date
	left join Date_dim ret
		on sp.PersRetirementDate = ret.Date
	left join Person p
		on sp.Retro_PersonId = p.Retro_PersonID
where sp.Retro_PersonId is not null
and p.Retro_PersonID is null

GO