USE AirCraftsDBNew62
GO

-- ������ ����� XML � ���� ��
-- ��������� ��� ����� �� �������� ���� �������������� xml, ��� �������� ��� ����
SET Transaction Isolation Level SERIALIZABLE
INSERT INTO dbo.AirCraftsTableNew2Xsd(AirLineOwner, AirLineOperator) VALUES ('<owner> 1 </owner> <date> 03.2010 </date>', '<operator> 2 </operator> <date> 03.2010 </date>')
GO
