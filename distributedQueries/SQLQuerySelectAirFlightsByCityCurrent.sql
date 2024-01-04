/*
На стороне сервера собираем вьюшку по авиаперелетам с регистрациями
Запрос в командном режиме "Меню SSMS" -> "Запрос" -> "Режим SQLCMD"
*/
DECLARE @RemoteServer VARCHAR(400)
SET @RemoteServer = 'data-server-1.movistar.vrn.skylink.local'
BEGIN TRY
	exec sp_addlinkedserver @server = @RemoteServer  -- срабатывает первый раз и работает на один сеанс работы в SSMS, на следующие разы выдает ошибку (с условием проверки наличия пока сложности, можно обернуть в обработку исключения)
	PRINT ' Внешний сервер = ' + @RemoteServer + ' привязан'
END TRY
BEGIN CATCH
	PRINT ' Внешний сервер = ' + @RemoteServer + ' уже привязан'
END CATCH

exec sp_linkedservers

-- Все делаем на стороне сервера
:CONNECT data-server-1.movistar.vrn.skylink.local
-- USE @RemoteServer.AirFlightsDBNew62WorkBase  -- выдает ошибку
SET STATISTICS XML ON
DECLARE @City VARCHAR(250), @Reg VARCHAR(50)
SET @Reg = 'N280WN'  -- 32101
PRINT ' Регистрация самолета = ' + @Reg
SET @City = 'Denver'
PRINT ' Аэропорт = ' + @City
SET Transaction Isolation Level Read Committed
/* ++++ Работает нормально ++++
SELECT TOP (1000) * FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirFlightsTable
--	WHERE AirCraftRegistration = @Reg
-- SELECT TOP (100000) * FROM @RemoteServer.AirFlightsDBNew62WorkBase.dbo.AirFlightsTable -- выдает ошибку
-- SELECT TOP (100000) * FROM LinkedServer.AirFlightsDBNew62WorkBase.dbo.AirFlightsTable -- выдает ошибку
GO
*/
-- Можно сначала выбрать все из внешней таблицы в промежуточный вид, а потом работать с ним
-- Но для промежуточного вида нет подходящей локальной базы
/*
CREATE VIEW AirFlightsView AS
 SELECT * FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirFlightsTable 
	WHERE AirFlightsDBNew62WorkBase.dbo.AirCraftsTable.AirCraftRegistration = @Reg
*/
-- Поэтому перегоняем все в локальные временные таблицы (нагружает tempdb и требует времени)
-- Надо на стороне сервера сделать вьюшку с регистрациями, чтобы не тянуть все с сервера (быстрее)
-- SELECT * INTO #AirFlightsTempTable FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirFlightsTable  -- работает, но выгребает каждый раз одно и то же

-- SELECT * INTO #AirCraftsTempTable FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirCraftsTable  -- работает, но выгребает каждый раз одно и то же
-- 	WHERE AirCraftRegistration = @Reg

-- :CONNECT data-server-1.movistar.vrn.skylink.local

-- собираем вьюшку (более экономно по ресурсам и быстрее)
SELECT  AirCraftsTable.AirCraftUniqueNumber,
		AirFlightsTable.AirCraft,
		AirFlightsTable.AirFlightUniqueNumber,
		AirCraftsTable.AirCraftRegistration,
		AirFlightsTable.FlightDate,
		AirFlightsTable.FlightNumberString,
		AirFlightsTable.QuantityCounted,
		AirCraftsTable.SourceCSVFile,
		AirFlightsTable.AirRoute  
	INTO #AirFlightsCraftsTempTable
		FROM    AirFlightsDBNew62WorkBase.dbo.AirFlightsTable INNER JOIN
				AirFlightsDBNew62WorkBase.dbo.AirCraftsTable ON AirFlightsDBNew62WorkBase.dbo.AirFlightsTable.AirCraft = AirCraftsTable.AirCraftUniqueNumber
			WHERE AirCraftRegistration = @Reg

SELECT * FROM #AirFlightsCraftsTempTable

-- Надо собрать вьюшку с этой временной таблицей и таблицами с этого сервера, но из-под другого подключения
-- Или лучше перенести ее на этот сервер и собрать вьюшку тут

/*
SELECT		#AirFlightsCraftsTempTable.FlightDate AS FLIGHTDATE,
			#AirFlightsCraftsTempTable.FlightNumberString AS FN,
			#AirFlightsCraftsTempTable.QuantityCounted,
			-- AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortName AS DEPARTURE,
			-- AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortCity AS CITY_OUT,
			-- AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortCodeIATA AS IATA_OUT,
			-- AirPortsTable_1.AirPortName AS ARRIVAL,
			-- AirPortsTable_1.AirPortCity AS CITY_IN,
			-- AirPortsTable_1.AirPortCodeIATA AS IATA_IN,
			#AirFlightsCraftsTempTable.SourceCSVFile AS SOURCEFILE
FROM		#AirFlightsCraftsTempTable INNER JOIN
            #AirFlightsCraftsTempTable ON #AirFlightsCraftsTempTable.AirCraft = #AirFlightsCraftsTempTable.AirCraftUniqueNumber INNER JOIN
            AirPortsAndRoutesDBNew62.dbo.AirRoutesTable ON #AirFlightsCraftsTempTable.AirRoute = AirPortsAndRoutesDBNew62.dbo.AirRoutesTable.AirRouteUniqueNumber INNER JOIN
            AirPortsAndRoutesDBNew62.dbo.AirPortsTable ON AirPortsAndRoutesDBNew62.dbo.AirRoutesTable.AirPortDeparture = AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortUniqueNumber INNER JOIN
            AirPortsAndRoutesDBNew62.dbo.AirPortsTable AS AirPortsTable_1 ON AirPortsAndRoutesDBNew62.dbo.AirRoutesTable.AirPortArrival = AirPortsTable_1.AirPortUniqueNumber  

FROM #AirFlightsCraftsTempTable
  WHERE #AirFlightsCraftsTempTable.AirCraftRegistration = @Reg
  ORDER BY FLIGHTDATE, FN

SELECT		AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortName AS DEPARTURE,
			AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortCity AS CITY_OUT,
			AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortCodeIATA AS IATA_OUT,
			AirPortsTable_1.AirPortName AS ARRIVAL,
			AirPortsTable_1.AirPortCity AS CITY_IN,
			AirPortsTable_1.AirPortCodeIATA AS IATA_IN,
			SUM(#AirFlightsCraftsTempTable.QuantityCounted) AS QUANTITY
FROM		#AirFlightsCraftsTempTable INNER JOIN
            #AirFlightsCraftsTempTable ON #AirFlightsCraftsTempTable.AirCraft = #AirFlightsCraftsTempTable.AirCraftUniqueNumber INNER JOIN
            AirPortsAndRoutesDBNew62.dbo.AirRoutesTable ON #AirFlightsCraftsTempTable.AirRoute = AirPortsAndRoutesDBNew62.dbo.AirRoutesTable.AirRouteUniqueNumber INNER JOIN
            AirPortsAndRoutesDBNew62.dbo.AirPortsTable ON AirPortsAndRoutesDBNew62.dbo.AirRoutesTable.AirPortDeparture = AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortUniqueNumber INNER JOIN
            AirPortsAndRoutesDBNew62.dbo.AirPortsTable AS AirPortsTable_1 ON AirPortsAndRoutesDBNew62.dbo.AirRoutesTable.AirPortArrival = AirPortsTable_1.AirPortUniqueNumber  
  WHERE #AirFlightsCraftsTempTable.AirCraftRegistration = @Reg
  GROUP BY	AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortName,
			AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortCity,
			AirPortsAndRoutesDBNew62.dbo.AirPortsTable.AirPortCodeIATA,
			AirPortsTable_1.AirPortName,
			AirPortsTable_1.AirPortCity,
			AirPortsTable_1.AirPortCodeIATA
  ORDER BY CITY_OUT, CITY_IN

-- Удаляем (очищаем локальные временные таблицы) -> Не требуется, таблицы исчезают после запроса
SET Transaction Isolation Level Serializable
-- DELETE FROM #AirFlightsTempTable
-- DELETE FROM #AirCraftsTempTable
GO
*/
