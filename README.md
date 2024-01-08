SQL-ные базы данных и XML-ные структуры данных, запросы, схемы, преобразования.
----

Структура хранилища с базами данных **Снежинка** - в центре таблицы с рабочими и оперативными данными (далее по тексту **данными**), с краев таблицы со справочными данными (далее по тексту **справочниками**). Далее в работе базы со справочниками на терминальном сервере с MS SQL Server Developer 15-й (выбор компонентов см. снимок экрана ниже),

![Установка v14 Выбор компонентов](https://github.com/tsv19su254052/LoadWorkData-Scripts/assets/104857185/aece1d7b-e113-4779-a7d6-d8f504fa78a5)

база с данными на сервере СУБД с MS SQL Server Enterprice 15-й (выбор компонентов см. снимок экрана ниже).

![Установка ENU 004](https://github.com/tsv19su254052/LoadWorkData-Scripts/assets/104857185/addef508-21f6-4808-ad9d-ae357edcf7f8)

Интерпретаторы Java и Python устанавливаеются дополнительно заранее. Модули машинного обучения подкидываются в процессе установки. Отладка автономными распределенными запросами и хранимыми процедурами с разнесенными транзакциями, иногда обернутыми в обработку исключения.

![Подключение 003 и результаты распределенного запроса](https://github.com/tsv19su254052/LoadWorkData-Scripts/assets/104857185/b5d59567-eb4d-4a47-b6bd-0bef36533401)

![Подключение 002 и результаты распределенного запроса](https://github.com/tsv19su254052/LoadWorkData-Scripts/assets/104857185/a7d0ce5a-28ff-456b-a6eb-2b89f96cc9c1)
 
 Таблица летательных аппаратов гибридная и содержит поля, которые правятся вручную и которые заполняются в процессе загрузки данных.
 
 Модель восстановления баз данных - **Полная**, так как предусматривается одновременная работа множества клиентов и в хранимых процедурах используются помеченные транзакции. Обслуживание баз данных (проверка целостности, обслуживание индексов, бэкапы) делается обычным способом - на время все действия клиентов ставим на паузу до уведомления о возобновлении работы. Права пользователей на доступ к базам данных соответсвуют их учеткам `Windows` на `SQL Server`-е.

Отчеты по базам данных:

![SSMS 001](https://github.com/tsv19su254052/LoadWorkData-Scripts/assets/104857185/0d2fab10-d056-4458-ab94-0fa6faaf7a20)

![СУБД Полная - Простая - Сжатие - Полная 001 003](https://user-images.githubusercontent.com/37275122/168450358-630fa494-2c0f-4bad-afb1-42bdb44325ec.png)

![СУБД Полная - Простая - Сжатие - Полная 001 004](https://user-images.githubusercontent.com/37275122/168450362-8de3b141-e670-4067-a28e-544cd9cff239.png)

![SSMS СУБД Полная - Простая - Сжатие - Полная 001 002](https://github.com/tsv19su254052/LoadWorkData-Scripts/assets/104857185/2ebabdc5-807e-412b-b6fc-e99e17bea887)

Собрал **XML**-ные поля в таблицах:

![SSMS Делаем XML-ные поля](https://user-images.githubusercontent.com/104857185/173250391-229e37c8-c996-4d22-bf0f-7df07d0845b0.png)

Считаем, что в XML-ном поле регистрации может быть только один тэг с **аттрибутом-строкой**, обозначающим какую-то одну регистрацию.
Начало временного диапазона со следующей регистрацией считаем окончанием временного диапазона использования с предыдущей.
Заполняем только ручным вводом.

Считаем, что в каждом XML-ном поле авиакомпании может быть только один тэг с **аттрибутом-идентификатором**, указывающим на какую-то одну авиакомпанию.
Начало временного диапазона в следующей авиакомпании считаем окончанием временного диапазона использования в предыдущей.
Аттрибуты-идентификаторы в разных XML-ных полях могут указывать на одну и ту же авиакомпанию (см. второй абзац ["Считаем, что ..."](https://github.com/tsv19su254052/LoadWorkData-GUIs-and-Utilities#%D1%81%D0%BF%D1%80%D0%B0%D0%B2%D0%BE%D1%87%D0%BD%D0%B8%D0%BA%D0%B8-%D0%B8-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D0%B5)).

![SSMS - сделал XML-ное поле хабов](https://user-images.githubusercontent.com/104857185/221209485-7197219f-011a-4033-bac2-d2f5de120600.png)

Теперь можно не писать **XSD-схему** вручную с нуля, а сгенерировать в `Management Studio` (аскетичнее, архаичнее, но срабатывает точнее)

![SSMS - XML-код - Создать схему](https://user-images.githubusercontent.com/104857185/167261451-a42a0c66-2888-4042-88a2-679f1ef6549a.png)

или в `pyCharm`-е (удобнее в плане подсветки синтаксиса и автодополнения, есть навигация по структуре).

![pyCharm - генерация XSD-схемы](https://user-images.githubusercontent.com/104857185/219681278-eeec7953-a13d-4ac6-8e42-787312e2caba.png)

Добавил подмодуль `Schematron`-а в `pyCharm`-е:

![pyCharm - добавил подмодуль Schematron-а в BaseX](https://user-images.githubusercontent.com/104857185/221182787-665e3add-c00d-40ea-83f9-e2db1e2ca7f7.png)

Подправил собранную XSD-схему:

![pyCharm - собираю XSD-схему](https://user-images.githubusercontent.com/104857185/221181126-ef7f3812-9cc1-409d-b998-0b51b725d844.png)

Вставил собранную XSD-схему в скрипт привязки и привязал ее к базе:

![SSMS - привязал схему](https://user-images.githubusercontent.com/104857185/221206221-97c4d302-ef48-4b42-9163-f15e3559d94a.png)

Для удобства восприятия можно привязать к базе несколько коллекций XSD-схем, вставив в каждый скрипт привязки по одной XSD-схеме.

Коротко отмечу, что в начале XSD-схемы объявляются:
 - типовые и ссылочные схемы,
 - [типовые, ссылочные и пользовательские пространства имен](https://www.w3.org/TR/xmlschema11-1),
 - типовые, ссылочные и пользовательские типы данных `XPath & XQuery`.

В XSD-схеме определяем [элементы](https://www.w3schools.com/xml/schema_simple.asp), каждый под своим именем. Полученные таким образом или с помощью [XSLT-преобразования](https://docs.microsoft.com/ru-ru/visualstudio/xml-tools/how-to-execute-an-xslt-transformation-from-the-xml-editor?view=vs-2022) схемы вставляем в общую схему в соответствии с порядком просмотра XML-ных полей. В сложных случаях можно пользоваться [Schematron](https://www.schematron.com )-ом как импортированным модулем внутри среды управления [BaseX](https://en.wikipedia.org/wiki/BaseX).

![Base X - установил плагин Schematron-а](https://user-images.githubusercontent.com/104857185/220959166-377d2b44-bc79-4e97-b3f1-87393aa887c7.png)

Имя корневого тэга XML-ного поля соответствует имени элемента XSD-схемы. Исходный текст XSD-схемы вставляем в SQL-ный скрипт ее привязки к базе данных.
Набрал эталонные XML-ные файлы по хабам и привязал их к собранной XSD-схеме в `Management Studio`:

![SSMS - собираю исходные XML-ный файлы по хабам с привязкой к собранной XSD-схеме](https://user-images.githubusercontent.com/104857185/221206489-25b6699c-a312-47c6-a63d-0010e67985e6.png)

Результаты привязки:

![SSMS Сборка XSD-схемы](https://user-images.githubusercontent.com/104857185/174197029-1815510f-f813-4244-8b73-d79f40e28064.png)
 
![SSMS - привязал схему к базе 001](https://user-images.githubusercontent.com/104857185/221229955-6c2162ff-0ee3-4524-ad33-6218847b5e2d.png)

Поправки по терминологии:
 - **Коллекцию схем XML** в `Management Studio` точнее называть XSD-схемой.
 - **Созданием схемы** в SQL-ном скрипте правильнее называть привязкой XSD-схемы, потому что она уже собрана и сохранена файлом типа `*.xsd`.
 - [DTD-схемы](https://en.wikipedia.org/wiki/Document_type_definition) (старые и малофункциональные) и [XDR-схемы](https://learn.microsoft.com/ru-ru/sql/relational-databases/xml/generate-an-inline-xdr-schema?view=sql-server-ver16) (были в ходу короткое время до появления XSD-схем) уже мало применяются.

XML-ные поля пропускаем через XSD-схему:
 - программно на входе хранимой процедуры,
 - программно при вставке или при обновлении строки,
 - при редактировании XML-ного файла с привязкой к XSD-схеме в `Management Studio`,
 - при ручном вводе XML-ного поля при вызове хранимой процедуры в `Management Studio`.

Так как сервер СУБД не дает обратные вызовы (вэб-хуки или программные прерывания) клиентам на повторную попытку,
если запрашиваемые данные пока заняты, то уход от взаимоблокировок при загрузке данных с нескольких внешних клиентов на сервер СУБД выполняем
обертыванием попытки запроса в обработку исключения внутри тела цикла с нарастающей задержкой по времени.
Выход из цикла - получение результата запроса или превышение определенного максимума попыток.

Без обратных вызовов пока не получается эффективно задействовать внешний сервер СУБД. Транзакции сделаны короткими, но между ними все перезапрашивается снова, так как данные изменяются другими клиентами. Потери времени на задержках частично уменьшены путем уточнения уровня изоляции транзакции в зависимости от действия. Число перезапросов и их перенос по времени пишутся в журнал загрузки рабочих данных (см. `LogReport_DBNew6.txt` в папке проекта на сервере), ошибки дозаписи в него - в журнал ошибок (см. `ErrorLog.txt` там же). Начальное значение задержки по времени и шаг ее приращения подобран экспериментально по результатам нагрузочных тестов осенью 2019-го года и зависит от вычислительных характеристик сервера СУБД. При 2-х кратном увеличении количества клиентов задержки увеличиваются на 15 ... 20 %, а нагрузка на сервер СУБД (процессор, HDD) уменьшается на 25 ... 35 % благодаря удачно проиндексированным полям в таблицах. Траффик по локальной подсети увеличивается из-за перезапросов
