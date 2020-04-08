Create Procedure create_person

AS

Create Table Person

(
	PersonKey					int			not null	Identity(10001, 1)		Primary Key		,
	Retro_PersonID				varchar(20)	Unique												,
	Lahman_PersonID				varchar(20)														,
	BBREF_PersonID				varchar(20)														,
	PersFirstName				varchar(35)														,
	PersLastName				varchar(35)														,
	PersGivenName				varchar(80)														,
	PersBirthDateKey			int																,
	PersBirthCountry			varchar(50)														,
	PersBirthState				varchar(4)														,
	PersBirthCity				varchar(35)														,
	DeathDateKey				int																,
	PersWeight					smallint														,
	PersHeight					tinyint															,
	PersBattingHand				char(1)															,
	PersThrowingHand			char(1)															,
	PersDebutDateKey			int																,
	PersRetirementDateKey		int																					
)

GO