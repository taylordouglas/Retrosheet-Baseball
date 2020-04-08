DECLARE @table Nvarchar(50)
	, @schema Nvarchar(10)
	, @sqlcmd Nvarchar(max)



DECLARE db_cursor CURSOR FOR 
SELECT table_name, table_schema from INFORMATION_SCHEMA.tables
WHERE TABLE_NAME IN 
(
'ACTIONFACT'
, 'GAMEFACT'
, 'PLAYFACT'
, 'GAME'
, 'PITCHBYPITCH'
, 'PLAYBYPLAY'
, 'ACTIONBYCOUNT'
)


OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @table, @schema 

WHILE @@FETCH_STATUS = 0  
BEGIN  
      SET @sqlcmd = 'TRUNCATE TABLE '  + @SCHEMA + '.' +  @table   
      
	  EXEC SP_EXECUTESQL @SQLCMD

      FETCH NEXT FROM db_cursor INTO @table, @schema  
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 






