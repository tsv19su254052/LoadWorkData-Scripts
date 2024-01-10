SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		������� ������
-- Create date:	29 ������ 2021 ����
-- ��������:	11 ���� 2022 ����
-- Description:	������� ��� ���������� ������ ��������
-- =============================================
CREATE PROCEDURE [dbo].[SPUpdateAirCraft] (@pk BIGINT, @LN varchar(100), @MSN varchar(100), @SN varchar(100), @CN varchar(100), @registration XML(dbo.SchemaCollectionXsd), @operator XML(dbo.SchemaCollectionXsd), @owner XML(dbo.SchemaCollectionXsd))
-- todo ��������� ������� xml-��� ������ ������� -> @registration XML(CONTENT dbo.SchemaCollection)
-- todo ������������ ��������� �� ������
AS
BEGIN
	-- ���� ���������
	SET XACT_ABORT ON -- ��������� �������� ��������� ����������, ������ �� ����, ��� ������������ ����� ����� ������� ������ ���� ����������
	SET NOCOUNT ON; -- ������� ����������� "row(s) affected", SET NOCOUNT ON added to prevent extra result sets from
	-- ���� ���������
	BEGIN TRY
		-- ��������� ���� ��������, �� ������������� ��������������� � ������ ������� � ������� �������� ������� � �������� ���������
		-- ��������� ������� �� UPDATE � DELETE 
		DECLARE @TransactionName VARCHAR(32)
		SET @TransactionName = CONCAT('Transaction_SelectCountOf_', @pk)  -- ������������ <= 32 ��������
		SET Transaction Isolation Level Repeatable Read
		BEGIN TRANSACTION @TransactionName WITH MARK  -- ������� ���������� (�������� � SQL Server 2008-��)
			-- ��������� ������ � ����������� ��� ���� ������ �� ���� ��������� (���������� ������)
			UPDATE dbo.AirCraftsTableNew2Xsd SET AirCraftLineNumber_LN = @LN, AirCraftLineNumber_MSN = @MSN, AirCraftSerialNumber_SN = @SN, AirCraftCNumber = @CN, AirCraftRegistration = @registration, AirLineOperator = @operator, AirLineOwner = @owner
				WHERE AirCraftUniqueNumber = @pk
		COMMIT TRANSACTION @TransactionName
	END TRY

	-- ��������� ����������
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION  -- ��� ����� ���� ���������, �� "RowInsertionWithParam"
		DECLARE @msg NVARCHAR(2048) = error_message() -- ����� ������
		RAISERROR (@msg, 16, 1)
		RETURN 55555 -- ������ ��������� ��� SQL Server 2005  � ����� ������ (�� ������������ � ���������)
	END CATCH

	PRINT @TransactionName
	-- ��������� �������
	SET XACT_ABORT OFF
	SET NOCOUNT OFF
END
