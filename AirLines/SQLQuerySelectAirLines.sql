:CONNECT data-server-1.movistar.vrn.skylink.local
USE AirLinesDBNew62
GO

SELECT * 
  FROM dbo.AirLinesView
  -- WHERE AlianceName = 'U-FLY Alliance'
  ORDER BY AirLineCodeIATA, AirLineCodeICAO  -- 7100
GO