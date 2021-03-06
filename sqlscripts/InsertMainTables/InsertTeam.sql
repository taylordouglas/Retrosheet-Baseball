Create Procedure insert_team

AS

Insert Into Team (YearID	
				  , TeamID	
				  , LahmanID
				  , BBREFID	
				  , TeamName
				  , TeamPark	
				  , TeamLg	
				  , TeamDiv	
				  , FranchID)

Select YearID
	, teamIDRetro as TeamID
	, teamID as LahmanId
	, teamIDBR
	, name
	, park
	, lgid
	, divid
	, franchid
From Stage.Team
Order by YearID, teamIDretro

GO