USE AirCraftsDBNew62
GO

SET Transaction Isolation Level Serializable
-- SELECT * FROM dbo.AirCraftsTableNew2XsdIntermediate
  -- WHERE AirCraftLineNumber_LN = '472' AND AirCraftLineNumber_MSN = '32703'

DELETE FROM dbo.AirCraftsTableNew2XsdIntermediate WHERE AirCraftPK = 62929
GO
