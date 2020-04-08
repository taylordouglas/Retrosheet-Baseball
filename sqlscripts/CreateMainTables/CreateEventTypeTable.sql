Create Procedure create_EventType

As

Drop Table EventType

Create Table EventType
(
	EventType			int			not null	Primary Key	,
	EventDescription	varchar(50)	null					,
	IsHit				bit			null					,
	IsWalk				bit			null					,
	IsError				bit			null					,
	IsUnknown			bit			null					,	
)

GO