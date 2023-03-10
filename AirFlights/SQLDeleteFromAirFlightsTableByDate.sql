:CONNECT develop-server.movistar.vrn.skylink.local
DECLARE @faildate DATE
SET @faildate = '2022-11-01'  -- 
-- до
SELECT * 
  FROM AirFlightsDBNew62Test3.dbo.AirFlightsTable
  WHERE BeginDate = @faildate
SELECT * 
  FROM AirFlightsDBNew62Test4.dbo.AirFlightsTable
  WHERE BeginDate = @faildate
-- удаляем по дате
DELETE FROM AirFlightsDBNew62Test3.dbo.AirFlightsTable WHERE BeginDate = @faildate
DELETE FROM AirFlightsDBNew62Test4.dbo.AirFlightsTable WHERE BeginDate = @faildate
-- после
SELECT * 
  FROM AirFlightsDBNew62Test3.dbo.AirFlightsTable
  WHERE BeginDate = @faildate
SELECT * 
  FROM AirFlightsDBNew62Test4.dbo.AirFlightsTable
  WHERE BeginDate = @faildate
GO
