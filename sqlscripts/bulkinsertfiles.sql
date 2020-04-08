Bulk insert stage.PlayByPlay
                    From 'C:\backups\FileOutput\2010ANA.csv'
                    WITH
                    (
                    Firstrow = 1,
                    FieldTerminator = ',',
                    RowTerminator = '\n',
                    --TABLOCK,
					Format = 'CSV'
                    )

