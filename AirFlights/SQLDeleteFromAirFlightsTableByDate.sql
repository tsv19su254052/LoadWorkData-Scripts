:CONNECT develop-server.movistar.vrn.skylink.local
USE AirFlightsDBNew62Test4
GO

DECLARE @faildate DATE
SET @faildate = '2022-11-01'  -- 

SELECT * 
  FROM dbo.AirFlightsTable
  WHERE BeginDate = @faildate

DELETE FROM dbo.AirFlightsTable WHERE BeginDate = @faildate

SELECT * 
  FROM dbo.AirFlightsTable
  WHERE BeginDate = @faildate
GO
