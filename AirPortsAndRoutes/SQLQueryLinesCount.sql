USE AirPortsAndRoutesDBNew62
GO

--  ����� ����� � ������� 
SET Transaction Isolation Level Serializable
-- SELECT COUNT(*) FROM dbo.AirFlightsTable -- INT ��� BIGINT ������������ �������������� ����
-- SELECT COUNT_BIG(*) FROM dbo.AirFlightsTable  -- BIGINT � ����� ��������������� ���� ������

SELECT COUNT(*) AS COUNT FROM dbo.AirPortsTable -- INT ��� BIGINT ������������ �������������� ����
SELECT COUNT_BIG(*) FROM dbo.AirPortsTable  -- BIGINT � ����� ��������������� ���� ������
