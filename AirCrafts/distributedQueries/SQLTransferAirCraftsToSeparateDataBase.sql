-- ������ ������� ������ �� ��������� �� ���� � �������������� � ��������� ����
-- ���� �������:
-- - ��������,
-- - ������,
-- - ������-������������,
-- - �������� - ��������� ������� � ���� �������������. �� ���� ��� �������� ������, ������� ����� �������� � ��� �������

SET STATISTICS XML ON

/*
DECLARE @RemoteServer NVARCHAR(500)
SET @RemoteServer = 'data-server-1.movistar.vrn.skylink.local'

BEGIN TRY
	exec sp_addlinkedserver @server = @RemoteServer  -- ����������� ���� ���, �� ������ �� � ������� ���� (����� ������� � ��������� ������) � �������� �� ����� ������ � SSMS, �� ��������� ���� ������ ������
	PRINT ' ������� ������ = ' + @RemoteServer + ' ��������'
END TRY
BEGIN CATCH
	PRINT ' ������� ������ = ' + @RemoteServer + ' �� ���������� (��� ��������)'
END CATCH
*/

-- exec sp_linkedservers

SET Transaction Isolation Level Serializable
-- ������ ������� (��� �������� ������������ ������� �� ���������)
BEGIN TRY
	-- ������� ��� ������� ������������� �������, ���� ��� ��� ����
	-- DROP TABLE IF EXISTS AirCraftsDBNew62.dbo.AirCraftsTableNew2XsdIntermediate
	TRUNCATE TABLE AirCraftsDBNew62.dbo.AirCraftsTableNew2XsdIntermediate
	PRINT ' ������������� ������� �������'
END TRY
BEGIN CATCH
	PRINT ' ������ ������������� �������'
	-- ������ ������������� �������
	-- ����� �������� ��������� ������� ��� ������� �������
	CREATE TABLE AirCraftsDBNew62.dbo.AirCraftsTableNew2XsdIntermediate (
			AirCraftPK BIGINT NOT NULL IDENTITY PRIMARY KEY,
			AirCraftRegistrationOld NVARCHAR(50),
			AirCraftRegistration XML(CONTENT dbo.SchemaCollectionXSD),
			AirCraftModel BIGINT FOREIGN KEY REFERENCES AirCraftsDBNew62.dbo.AirCraftModelsTable(AirCraftModelUniqueNumber),  -- ����� �������������� � ���������� ��� ������������ -> �������� �������, �� ���� �� ��������
			BuildDate DATE,
			RetireDate DATE,
			SourceCSVFile NTEXT,
			AirCraftDescription NTEXT,
			AirCraftLineNumber_LN_OLD NVARCHAR(50),
			AirCraftLineNumber_LN_NEW BIGINT,
			AirCraftSerialNumber_SN_OLD NVARCHAR(50),
			AirCraftCNumber_CN NVARCHAR(50),
			EndDate DATE)
END CATCH

-- �������� ��������� ������ �� ��������� �� ���� ������������� � ������������� �������
SET Transaction Isolation Level Serializable
INSERT INTO AirCraftsDBNew62.dbo.AirCraftsTableNew2XsdIntermediate (
		AirCraftRegistrationOld,
		AirCraftModel,
		BuildDate,
		RetireDate,
		SourceCSVFile,
		AirCraftDescription,
		AirCraftLineNumber_LN_OLD,
		AirCraftLineNumber_LN_NEW,
		AirCraftSerialNumber_SN_OLD,
		AirCraftCNumber_CN,
		EndDate)
	SELECT AirCraftRegistration,  -- ������������� � XML-��� ���� �� ����� ������������� �������
		(AirCraftModel + 201),  -- ����� �� 201 � ������� ���������
		BuildDate,
		RetireDate,
		SourceCSVFile,
		AirCraftDescription,
		AirCraftLineNumber_LN_MSN,  -- ��������� ��� ������, �������������� � BIGINT, �������� 'nan' � ��� ��������� �� ������ ������ -> ������
		TRY_CAST(TRY_CAST(AirCraftLineNumber_LN_MSN AS FLOAT) AS BIGINT),  -- �������������� � BIGINT, �������� 'nan' � ��� ��������� �� ������ ������ -> ������ � 2 ����
		AirCraftSerialNumber_SN,  -- ��������� ��� ������
		AirCraftCNumber,
		-- TRY_CONVERT(BIGINT, AirCraftCNumber),  -- ���� ��������� ��� ������
		EndDate
		FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirCraftsTable

-- ������ ������� ����� ��������� ������� (��� �������� ������������ ������� �� ���������) - �� �������

/*
SELECT	AirCraftRegistration,  -- ������������� � XML-��� ���� �� ����� ������������� �������
		(AirCraftModel + 201),  -- ����� �� 201 � ������� ���������
		BuildDate,  -- ���� ��������� ��� ������
		RetireDate,  -- ���� ��������� ��� ������
		SourceCSVFile,
		AirCraftDescription,
		AirCraftLineNumber_LN_MSN,  -- ���� ��������� ��� ������, �������������� � BIGINT, �������� 'nan' � ��� ��������� �� ������ ������ -> ������
		AirCraftLineNumber_LN_NEW AS TRY_CAST(TRY_CAST(AirCraftLineNumber_LN_MSN AS FLOAT) AS BIGINT),  -- ���� ��������� ��� ������, �������������� � BIGINT, �������� 'nan' � ��� ��������� �� ������ ������ -> ������
		AirCraftSerialNumber_SN,  -- ���� ��������� ��� ������
		AirCraftCNumber,
		-- TRY_CONVERT(BIGINT, AirCraftCNumber),  -- ���� ��������� ��� ������, �������������� � BIGINT, �������� 'nan' � ��� ��������� �� ������ ������ -> ������
		EndDate  -- ���� ��������� ��� ������
	INTO  ##AirCraftsTableNew2XsdIntermediate  -- �� ��������� ������� (�������� ��� ������ ��������)
		FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirCraftsTable

SELECT * FROM ##AirCraftsTableNew2XsdIntermediate
*/
