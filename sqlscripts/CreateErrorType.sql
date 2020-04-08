Use Retrosheet
go

Create Table ErrorType

(
	ErrorTypeId int not null Identity(1,1) Primary Key,
	ErrorTypeRetroCode varchar(1) not null,
	ErrorTypeDescription varchar(50) not null

)
go



