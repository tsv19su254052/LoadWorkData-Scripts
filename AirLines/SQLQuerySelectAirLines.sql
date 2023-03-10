:CONNECT data-server-1.movistar.vrn.skylink.local
USE AirLinesDBNew62
GO

SET STATISTICS XML ON
SET Transaction Isolation Level Read Committed
SELECT * FROM dbo.AirLinesView
  ORDER BY AirLineCodeIATA, AirLineCodeICAO  -- 7112

SELECT  dbo.AlliancesTable.AllianceName, 
		dbo.AirLinesTable.AirLineName, 
		dbo.AirLinesTable.AirLineAlias, 
		dbo.AirLinesTable.AirLineCodeIATA, 
		dbo.AirLinesTable.AirLineCodeICAO, 
		dbo.AirLinesTable.AirLine_ID, 
		dbo.AirLinesTable.AirLineCallSighn, 
		dbo.AirLinesTable.AirLineCountry, 
		dbo.AirLinesTable.AirLineStatus, 
		dbo.AirLinesTable.CreationDate, 
		-- dbo.AirLinesTable.AirLineDescription,
		dbo.AirLinesTable.Hubs
FROM dbo.AirLinesTable INNER JOIN dbo.AlliancesTable ON dbo.AirLinesTable.Alliance = dbo.AlliancesTable.AllianceUniqueNumber
  -- WHERE AllianceName = 'ASL Aviation Holdings DAC'
  WHERE dbo.AirLinesTable.AirLineCodeIATA = '3S' AND dbo.AirLinesTable.AirLineCodeICAO = 'BOX'
  ORDER BY AirLineCodeIATA, AirLineCodeICAO
GO