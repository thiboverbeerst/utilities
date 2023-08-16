CREATE DATABASE SevenSeas
ON
    (FILENAME = '/var/opt/mssql/data/SevenSeas.mdf'),
    (FILENAME = '/var/opt/mssql/data/SevenSeas_log.ldf')
FOR ATTACH;