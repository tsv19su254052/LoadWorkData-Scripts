:CONNECT terminalserver\mssqlserver15
USE AirFlightsDBNew62WorkBase
GO

DECLARE @faildate DATE
SET @faildate = '2023-04-01'  -- 

-- за указанный месяц
SELECT * 
  FROM AirFlightsTable
  WHERE BeginDate = @faildate
  ORDER BY FlightDate

-- удаляем по дате
DELETE FROM AirFlightsDBNew62WorkBase.dbo.AirFlightsTable WHERE BeginDate = @faildate

-- за указанный месяц и далее
SELECT * 
  FROM AirFlightsTable
  WHERE BeginDate >= @faildate
  ORDER BY FlightDate
GO
