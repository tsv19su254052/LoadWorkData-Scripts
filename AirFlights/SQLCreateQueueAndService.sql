USE AirFlightsDBNew62
GO
-- �������� ������� �� �������
CREATE QUEUE dbo.AirFlightsQueue
GO
-- �������� ������
CREATE SERVICE AirFlightsService ON QUEUE dbo.AirFlightsQueue
GO