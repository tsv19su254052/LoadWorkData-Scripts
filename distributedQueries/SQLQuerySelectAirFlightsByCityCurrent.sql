/*
�� ������� ������� �������� ������ �� ������������� � �������������
������ � ��������� ������ "���� SSMS" -> "������" -> "����� SQLCMD"
*/
DECLARE @RemoteServer VARCHAR(400)
SET @RemoteServer = 'data-server-1.movistar.vrn.skylink.local'
BEGIN TRY
	exec sp_addlinkedserver @server = @RemoteServer  -- ����������� ������ ��� � �������� �� ���� ����� ������ � SSMS, �� ��������� ���� ������ ������ (� �������� �������� ������� ���� ���������, ����� �������� � ��������� ����������)
	PRINT ' ������� ������ = ' + @RemoteServer + ' ��������'
END TRY
BEGIN CATCH
	PRINT ' ������� ������ = ' + @RemoteServer + ' ��� ��������'
END CATCH

exec sp_linkedservers

-- ��� ������ �� ������� �������
:CONNECT data-server-1.movistar.vrn.skylink.local
-- USE @RemoteServer.AirFlightsDBNew62WorkBase  -- ������ ������
SET STATISTICS XML ON
DECLARE @City VARCHAR(250), @Reg VARCHAR(50)
SET @Reg = 'N280WN'  -- 32101
PRINT ' ����������� �������� = ' + @Reg
SET @City = 'Denver'
PRINT ' �������� = ' + @City
SET Transaction Isolation Level Read Committed
/* ++++ �������� ��������� ++++
SELECT TOP (1000) * FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirFlightsTable
--	WHERE AirCraftRegistration = @Reg
-- SELECT TOP (100000) * FROM @RemoteServer.AirFlightsDBNew62WorkBase.dbo.AirFlightsTable -- ������ ������
-- SELECT TOP (100000) * FROM LinkedServer.AirFlightsDBNew62WorkBase.dbo.AirFlightsTable -- ������ ������
GO
*/
-- ����� ������� ������� ��� �� ������� ������� � ������������� ���, � ����� �������� � ���
-- �� ��� �������������� ���� ��� ���������� ��������� ����
/*
CREATE VIEW AirFlightsView AS
 SELECT * FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirFlightsTable 
	WHERE AirFlightsDBNew62WorkBase.dbo.AirCraftsTable.AirCraftRegistration = @Reg
*/
-- ������� ���������� ��� � ��������� ��������� ������� (��������� tempdb � ������� �������)
-- ���� �� ������� ������� ������� ������ � �������������, ����� �� ������ ��� � ������� (�������)
-- SELECT * INTO #AirFlightsTempTable FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirFlightsTable  -- ��������, �� ��������� ������ ��� ���� � �� ��

-- SELECT * INTO #AirCraftsTempTable FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirCraftsTable  -- ��������, �� ��������� ������ ��� ���� � �� ��
-- 	WHERE AirCraftRegistration = @Reg

-- :CONNECT data-server-1.movistar.vrn.skylink.local

-- �������� ������ (����� �������� �� �������� � �������)
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

-- ���� ������� ������ � ���� ��������� �������� � ��������� � ����� �������, �� ��-��� ������� �����������
-- ��� ����� ��������� �� �� ���� ������ � ������� ������ ���

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

-- ������� (������� ��������� ��������� �������) -> �� ���������, ������� �������� ����� �������
SET Transaction Isolation Level Serializable
-- DELETE FROM #AirFlightsTempTable
-- DELETE FROM #AirCraftsTempTable
GO
*/
