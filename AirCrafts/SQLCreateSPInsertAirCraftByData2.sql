USE [AirCraftsDBNew62]
GO
/****** Object:  StoredProcedure [dbo].[SPInsertAirCraft]    Script Date: 07.01.2024 2:27:04 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Тарасов СЕРГЕЙ
-- Create date:	29 апреля 2021 года
-- Изменено:	11 июня 2022 года
-- Description:	Вставка данных самолета
-- =============================================
ALTER PROCEDURE [dbo].[SPInsertAirCraft] (@model BIGINT, @LN numeric(18, 0), @MSN numeric(24, 0), @SN numeric(18, 0), @CN numeric(18, 0), @builddate DATE, @registration XML(dbo.SchemaCollectionXsd), @operator XML(dbo.SchemaCollectionXsd), @owner XML(dbo.SchemaCollectionXsd), @landlord XML(dbo.SchemaCollectionXsd), @lessor XML(dbo.SchemaCollectionXsd))
AS
BEGIN
	-- Тело процедуры
	SET XACT_ABORT ON -- закрываем открытые безхозные транзакции, исходя из того, что одновременно пусть будет открыта только одна транзакция
	SET NOCOUNT ON; -- снимаем ограничение "row(s) affected", SET NOCOUNT ON added to prevent extra result sets from
	-- Тело процедуры
	BEGIN TRY
		-- Первичный ключ уникален, но присваивается автоинкрементом в разных сессиях и поэтому возможны разрывы в сквозной нумерации
		-- Каскадные правила на UPDATE и DELETE 
		DECLARE @TransactionName VARCHAR(32)
		SET @TransactionName = CONCAT('Transaction_Count_', @LN)  -- используются <= 32 символов
		SET Transaction Isolation Level SERIALIZABLE
		BEGIN TRANSACTION @TransactionName WITH MARK  -- пометка транзакции (работает с 2008-го SQL Server-а)
			-- Вставляет строку с параметрами, как было подано на вход процедуры (простейший случай)
			INSERT INTO dbo.AirCraftsTableNew2Xsd (AirCraftModel, AirCraftLineNumber_LN, AirCraftLineNumber_MSN, AirCraftSerialNumber_SN, AirCraftCNumber, BuildDate, AirCraftRegistration, AirLineOperator, AirLineOwner, AirLineLandLord, AirLineLessor) VALUES (@model, @LN, @MSN, @SN, @CN, @builddate, @registration, @operator, @owner, @landlord, @lessor)
			-- INSERT INTO dbo.AirCraftsTableNew2Xsd (AirCraftModel, AirCraftLineNumber_LN, AirCraftLineNumber_MSN, AirCraftSerialNumber_SN, AirCraftCNumber, BuildDate, AirCraftRegistration, AirLineOperator, AirLineOwner) VALUES (@model, @LN, @MSN, @SN, @CN, @builddate, @registration, @operator, @owner)
		COMMIT TRANSACTION @TransactionName
	END TRY

	-- Обработка исключения
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION  -- это откат всей процедуры, не "RowInsertionWithParam"
		DECLARE @msg NVARCHAR(2048) = error_message() -- текст ошибки
		RAISERROR (@msg, 16, 1)
		RETURN 55555 -- просто страховка для SQL Server 2005  и более ранних (не использовать в триггерах)
	END CATCH

	PRINT @TransactionName
	-- Выключаем обратно
	SET XACT_ABORT OFF
	SET NOCOUNT OFF
END
