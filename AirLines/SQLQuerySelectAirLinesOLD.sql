/****** Script for SelectTopNRows command from SSMS  ******/
:CONNECT data-server-1.movistar.vrn.skylink.local
-- :CONNECT terminalserver\mssqlserver15
USE AirLinesDBNew62
GO
/* Авиакомпании  */
SELECT AirLineName AS AIRLINE,
       AirLineAlias AS ALIAS,
	   AirLineCodeIATA AS IATA,
	   AirLineCodeICAO AS ICAO,
	   AirLineCallSighn AS CALLSIGN,
	   AirLineCity AS CITY,
	   AirLineCountry AS COUNTRY,
	   AirLineDescription,
	   AllianceName AS ALIANCE,
	   AirLine_ID
  FROM dbo.AirLinesViewOLD
  WHERE AirLineCodeIATA = 'Z0' OR AirLineCodeICAO = 'UBT'
  ORDER BY AIRLINE, ALIAS
  -- Почистить ячейки, убрать дубликаты 
  GO