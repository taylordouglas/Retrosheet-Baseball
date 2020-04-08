Use Retrosheet

Create Table stage.FileImports

(
	ImportId int Identity(1,1) not null Primary Key,
	ImportedFile varchar(100) null,
	RowsInserted int	null,
	InsertTime datetime, 
)

