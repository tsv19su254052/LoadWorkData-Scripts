-- Делаем перенос данных по самолетам из базы с авиаперелетами в отдельную базу
-- Пото таблицы:
-- - самолеты,
-- - модели,
-- - заводы-изготовители,
-- - аллиансы - переносим обратно в базу авиаперелетов. Но пока нет исходных данных, которые можно заливать в эти таблицы

SET STATISTICS XML ON

/*
DECLARE @RemoteServer NVARCHAR(500)
SET @RemoteServer = 'data-server-1.movistar.vrn.skylink.local'

BEGIN TRY
	exec sp_addlinkedserver @server = @RemoteServer  -- срабатывает один раз, но иногда не с первого раза (лучше вынести в отдельный запрос) и работает на сеанс работы в SSMS, на следующие разы выдает ошибку
	PRINT ' Внешний сервер = ' + @RemoteServer + ' привязан'
END TRY
BEGIN CATCH
	PRINT ' Внешний сервер = ' + @RemoteServer + ' не привязался (уже привязан)'
END CATCH
*/

-- exec sp_linkedservers

SET Transaction Isolation Level Serializable
-- Первый вариант (без проверки существующих записей на дубликаты)
BEGIN TRY
	-- Удаляем или очищаем промежуточную таблицу, если она уже была
	-- DROP TABLE IF EXISTS AirCraftsDBNew62.dbo.AirCraftsTableNew2XsdIntermediate
	TRUNCATE TABLE AirCraftsDBNew62.dbo.AirCraftsTableNew2XsdIntermediate
	PRINT ' Промежуточная таблица очищена'
END TRY
BEGIN CATCH
	PRINT ' Делаем промежуточную таблицу'
	-- Делаем промежуточную таблицу
	-- После внесения изменений удалить эту таблицу вручную
	CREATE TABLE AirCraftsDBNew62.dbo.AirCraftsTableNew2XsdIntermediate (
			AirCraftPK BIGINT NOT NULL IDENTITY PRIMARY KEY,
			AirCraftRegistrationOld NVARCHAR(50),
			AirCraftRegistration XML(CONTENT dbo.SchemaCollectionXSD),
			AirCraftModel BIGINT FOREIGN KEY REFERENCES AirCraftsDBNew62.dbo.AirCraftModelsTable(AirCraftModelUniqueNumber),  -- между авиаперелетами и самолетами нет соответствия -> ИСПРАВИЛ СДВИГОМ, но ключ не ставится
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

-- Копируем пригодные данные по самолетам из базы авиаперелетов в промежуточную таблицу
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
	SELECT AirCraftRegistration,  -- преобразовать в XML-ное поле по ранее определенному шаблону
		(AirCraftModel + 201),  -- сдвиг на 201 в моделях самолетов
		BuildDate,
		RetireDate,
		SourceCSVFile,
		AirCraftDescription,
		AirCraftLineNumber_LN_MSN,  -- проверять тип данных, конвертировать в BIGINT, заменить 'nan' и все остальное на пустую ячейку -> СДЕЛАЛ
		TRY_CAST(TRY_CAST(AirCraftLineNumber_LN_MSN AS FLOAT) AS BIGINT),  -- конвертировать в BIGINT, заменить 'nan' и все остальное на пустую ячейку -> СДЕЛАЛ В 2 ХОДА
		AirCraftSerialNumber_SN,  -- проверять тип данных
		AirCraftCNumber,
		-- TRY_CONVERT(BIGINT, AirCraftCNumber),  -- надо проверять тип данных
		EndDate
		FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirCraftsTable

-- Второй вариант через временную таблицу (без проверки существующих записей на дубликаты) - НЕ ГОДИТСЯ

/*
SELECT	AirCraftRegistration,  -- преобразовать в XML-ное поле по ранее определенному шаблону
		(AirCraftModel + 201),  -- сдвиг на 201 в моделях самолетов
		BuildDate,  -- надо проверять тип данных
		RetireDate,  -- надо проверять тип данных
		SourceCSVFile,
		AirCraftDescription,
		AirCraftLineNumber_LN_MSN,  -- надо проверять тип данных, конвертировать в BIGINT, заменить 'nan' и все остальное на пустую ячейку -> СДЕЛАЛ
		AirCraftLineNumber_LN_NEW AS TRY_CAST(TRY_CAST(AirCraftLineNumber_LN_MSN AS FLOAT) AS BIGINT),  -- надо проверять тип данных, конвертировать в BIGINT, заменить 'nan' и все остальное на пустую ячейку -> СДЕЛАЛ
		AirCraftSerialNumber_SN,  -- надо проверять тип данных
		AirCraftCNumber,
		-- TRY_CONVERT(BIGINT, AirCraftCNumber),  -- надо проверять тип данных, конвертировать в BIGINT, заменить 'nan' и все остальное на пустую ячейку -> СДЕЛАЛ
		EndDate  -- надо проверять тип данных
	INTO  ##AirCraftsTableNew2XsdIntermediate  -- во временную таблицу (доступна для других запросов)
		FROM [data-server-1.movistar.vrn.skylink.local].AirFlightsDBNew62WorkBase.dbo.AirCraftsTable

SELECT * FROM ##AirCraftsTableNew2XsdIntermediate
*/
