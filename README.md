Структуры данных, запросы, схемы, преобразования.

Отчеты по базам данных из Management Studio

![СУБД Полная - Простая - Сжатие - Полная 001 003](https://user-images.githubusercontent.com/37275122/168450358-630fa494-2c0f-4bad-afb1-42bdb44325ec.png)

![СУБД Полная - Простая - Сжатие - Полная 001 004](https://user-images.githubusercontent.com/37275122/168450362-8de3b141-e670-4067-a28e-544cd9cff239.png)

![SSMS СУБД Полная - Простая - Сжатие - Полная 001 008](https://user-images.githubusercontent.com/104857185/175547592-7a6f3ec4-11e5-4601-be80-2ab19cc456c3.png)

Структура хранилища с базами данных
- **Снежинка** - в центре таблицы с рабочими и оперативными данными (далее по тексту **данными**), с краев - таблицы со справочными данными (далее по тексту **словарями**).
Таблица летательных аппаратов гибридная и содержит поля, которые правятся только вручную и которые заполняются в процессе загрузки данных.

Модель восстановления баз данных - **Полная**, так как предусматривается одновременная работа множества клиентов и в хранимых процедурах используются помеченные транзакции.
Обслуживание баз данных (проверка целостности, обслуживание индексов, бэкапы) делается обычным способом - на время все действия клиентов ставим на паузу до уведомления о возобновлении работы.

Права пользователей на доступ к базам данных соответсвуют их учеткам `Windows` на сервере СУБД.

Недостаток хранимой процедуры - не все результаты работы возвращает в скрипты на Python-е: получилось, не получилось с указанием причины
(см. [статью](https://docs.microsoft.com/ru-ru/sql/relational-databases/stored-procedures/return-data-from-a-stored-procedure?view=sql-server-ver15) ).
Особенность XSD-схемы - тот же и тот, что она пропускает все или не пропускает ничего.

Собираем **XML**-ные поля, определяемся с их структурой

![SSMS Делаем XML-ные поля](https://user-images.githubusercontent.com/104857185/173250391-229e37c8-c996-4d22-bf0f-7df07d0845b0.png)

В XML-ном поле регистрации может быть только один тэг с **аттрибутом-строкой**, обозначающим какую-то одну регистрацию.
Начало временного диапазона со следующей регистрацией считаем окончанием временного диапазона использования с предыдущей.
Заполняем только ручным вводом.

В каждом XML-ном поле авиакомпании может быть только один тэг с **аттрибутом-идентификатором**, указывающим на какую-то одну авиакомпанию.
Начало временного диапазона в следующей авиакомпании считаем окончанием временного диапазона использования в предыдущей.
Аттрибуты-идентификаторы в разных XML-ных полях могут указывать на одну и ту же авиакомпанию (см. выше 2 абзаца "Считаем, что ...").

Можно не писать **XSD-схему**, а сгенерировать ееч внутри SSMS (см. пример ниже)

![SSMS - XML-код - Создать схему](https://user-images.githubusercontent.com/104857185/167261451-a42a0c66-2888-4042-88a2-679f1ef6549a.png)

или внутри pyCharm (см. пример ниже)

![pyCharm - генерация XSD-схемы](https://user-images.githubusercontent.com/104857185/219681278-eeec7953-a13d-4ac6-8e42-787312e2caba.png)

В начале XSD-схемы объявляются:
 - типовые и ссылочные схемы,
 - [типовые, ссылочные и пользовательские пространства имен](https://www.w3.org/TR/xmlschema11-1),
 - типовые, ссылочные и пользовательские типы данных `XPath & XQuery`.

Далее в XSD-схеме определяются [элементы](https://www.w3schools.com/xml/schema_simple.asp), каждый под своим именем.

Элемент генерируется из XML-ного файла внутри `Management Studio` или с помощью [XSLT-преобразования](https://docs.microsoft.com/ru-ru/visualstudio/xml-tools/how-to-execute-an-xslt-transformation-from-the-xml-editor?view=vs-2022) 
и вставляется в соответствии с порядком просмотра XML-ных полей. В сложных случаях можно пользоваться [**Schematron**](https://www.schematron.com )-ом. 
Имя корневого тэга XML-ного поля соответствует имени элемента XSD-схемы.
Исходный текст XSD-схемы вставляется в SQL-ный скрипт ее привязки к базе данных
(надо найти способ не вставлять исходник схемы через буфер обмена, а выбирать ее в диалоге открытия файла или дать URL до нее `file:///P:/...`).
К базе данных можно привязать несколько XSD-схем.
К каждому XML-ному полю можно привязать свою XSD-схему.

Привязываем XSD-схему к базе данных

![SSMS Сборка XSD-схемы](https://user-images.githubusercontent.com/104857185/174197029-1815510f-f813-4244-8b73-d79f40e28064.png)
 
Поправки по терминологии:
 - **Коллекцию схем XML** в `Management Studio` точнее называть XSD-схемой.
 - **Созданием схемы** в SQL-ном скрипте правильнее называть привязкой XSD-схемы, потому что она уже собрана и сохранена файлом типа `*.xsd`.
 - **DTD-схемы** и **XDR-схемы** кратко упомянуты в [статье](https://docs.microsoft.com/ru-ru/visualstudio/xml-tools/how-to-create-an-xml-schema-from-an-xml-document?view=vs-2022),
   но уже не применяются.

XML-ные поля пропускаются через XSD-схему:
 - программно на входе хранимой процедуры,
 - программно при вставке или при обновлении строки,
 - при редактировании XML-ного файла с привязкой к XSD-схеме внутри `Management Studio`,
 - при ручном вводе XML-ного поля при вызове хранимой процедуры внутри `Management Studio`.

Так как сервер СУБД не дает обратные вызовы (вэб-хуки или программные прерывания) клиентам на повторную попытку,
если запрашиваемые данные пока заняты, то уход от взаимоблокировок при загрузке данных с нескольких внешних клиентов на сервер СУБД выполняется
обертыванием попытки запроса в обработку исключения внутри тела цикла с нарастающей задержкой по времени.
Выход из цикла - получение результата запроса или превышение определенного максимума попыток.

Без обратных вызовов пока не получается эффективно задействовать внешний сервер СУБД.
Транзакции сделаны короткими, но между ними все перезапрашивается снова, так как данные изменяются другими клиентами.
Потери времени на задержках частично уменьшены путем уточнения уровня изоляции транзакции в зависимости от действия.
Число перезапросов и их перенос по времени пишутся в журнал загрузки рабочих данных (см. `LogReport_DBNew6.txt` в папке проекта на сервере),
ошибки дозаписи в него - в журнал ошибок (см. `ErrorLog.txt` там же).
Начальное значение задержки по времени и шаг ее приращения подобран экспериментально по результатам нагрузочных тестов осенью 2019-го года
и зависит от вычислительных характеристик сервера СУБД. При 2-х кратном увеличении количества клиентов задержки увеличиваются на 15 ... 20 %,
а нагрузка на сервер СУБД (процессор, HDD) уменьшается на 25 ... 35 % благодаря удачно проиндексированным полям в таблицах.
Траффик по локальной подсети увеличивается из-за перезапросов. Пропускная способность локальной подсети достаточная.

