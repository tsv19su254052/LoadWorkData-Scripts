/*
�� ������� ������� �������� ��������� ������� �� ��������� ������ �� ������������� � �������������
*/
DECLARE @Reg VARCHAR(50)
SET @Reg = 'N270WN'  -- 25228
PRINT ' ����������� �������� = ' + @Reg

:CONNECT data-server-1.movistar.vrn.skylink.local
USE AirFlightsDBNew62WorkBase
SET STATISTICS XML ON
SET Transaction Isolation Level Read Committed
SELECT  AirCraftsTable.AirCraftUniqueNumber,
		AirFlightsTable.AirCraft,
		AirFlightsTable.AirFlightUniqueNumber,
		AirCraftsTable.AirCraftRegistration,
		AirFlightsTable.FlightDate,
		AirFlightsTable.FlightNumberString,
		AirFlightsTable.QuantityCounted,
		AirCraftsTable.SourceCSVFile,
		AirFlightsTable.AirRoute  
	INTO #AirFlightsCraftsTempTable  -- �� ������� ���������� ��������� ������� (��. ������ ������)
		FROM    AirFlightsTable INNER JOIN
				AirCraftsTable ON AirFlightsTable.AirCraft = AirCraftsTable.AirCraftUniqueNumber
			WHERE AirCraftRegistration = @Reg

SELECT * FROM #AirFlightsCraftsTempTable
