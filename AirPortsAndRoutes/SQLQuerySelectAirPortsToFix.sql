/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT AirPortCodeIATA, AirPortCodeICAO, AirPortName, AirPortCity, AirPortCounty, AirPortCountry, AirPortLatitude, AirPortLongitude, HeightAboveSeaLevel
  FROM [AirPortsAndRoutesDBNew62].[dbo].[AirPortsTable]
  -- WHERE AirPortCountry = 'United_States'
  ORDER BY AirPortCountry