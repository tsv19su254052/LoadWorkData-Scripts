DECLARE @RemoteServer NVARCHAR(500)
SET @RemoteServer = 'data-server-1.movistar.vrn.skylink.local'

exec sp_addlinkedserver @server = @RemoteServer
exec sp_linkedservers
