/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
:CONNECT develop-server.movistar.vrn.skylink.local
USE AirFlightsDBNew62Test3
GO

SELECT * 
  FROM dbo.AirCraftsViewFull
GO