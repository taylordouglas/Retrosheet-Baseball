Create Procedure create_lahmantables

AS

Select cast(playerid as varchar(20))												as Lah_PersonId
	, cast(nameFirst as varchar(35))												as PersFirstName
	, cast(nameLast as varchar(35))													as PersLastName
	, cast(nameGiven as varchar(80))												as PersGivenName

	, Cast(CONCAT(cast(birthYear as varchar(4)), Replicate('0', 2-len(cast(birthMonth as varchar(2)))), cast(birthMonth as varchar(2)), 
				Replicate('0', 2-len(cast(birthDay as varchar(2)))), cast(birthDay as varchar(2))) as int) as BirthDateKey
	, cast(birthCountry as varchar(50))												as PersBirthCountry
	, cast(birthState as varchar(4))												as PersBirthState
	, cast(birthCity as varchar(30))												as PersBirthCity
	, Cast(CONCAT(cast(deathYear as varchar(4)), Replicate('0', 2-len(cast(deathMonth as varchar(2)))), cast(deathMonth as varchar(2)), 
				Replicate('0', 2-len(cast(deathDay as varchar(2)))), cast(deathDay as varchar(2))) as int) as DeathDateKey
	, cast([weight] as smallint)													as PersWeight
	, cast(height as tinyint)														as PersHeight
	, cast(bats as varchar(2))														as PersBattingHand
	, cast(throws as varchar(2))														as PersThrowingHand
	, cast(debut as datetime)														as PersDebutDate
	, cast(FinalGame as datetime)													as PersRetirementDate
	, cast(retroid as varchar(20))													as Retro_PersonId
	, cast(bbrefID as varchar(20))													as BBREF_PersonId
into stage.Person
From LahmanBaseball..People


Select * 
into stage.Manager
From LahmanBaseball..Managers

Select * 
into stage.ManagerAward
From LahmanBaseball..AwardsManagers

Select ap.*
into stage.PlayerAward
From LahmanBaseball..AwardsPlayers ap


Select * 
into stage.ManagerAwardShare
From LahmanBaseball..AwardsShareManagers

Select asp.*
into stage.PlayerAwardShare
From LahmanBaseball..AwardsSharePlayers asp

Select * 
into Stage.Salary
from LahmanBaseball..Salaries

Select * 
into stage.AllstarAppearance
from LahmanBaseball..AllstarFull

GO
