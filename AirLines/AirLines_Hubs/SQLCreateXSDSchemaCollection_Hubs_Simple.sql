USE AirLinesDBNew62
GO

-- В кавычках вставить содержимое схемы из файла *.xsd
CREATE XML SCHEMA COLLECTION SchemaHubs_Simple AS '
<!-- Начало вставки сводной XSD-схемы -->

<!-- Вверху сводный перечень пространств имен, todo Дополнить шапку из сгенерированной XSD-схемы -->
<xs:schema  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			attributeFormDefault="unqualified" 
			elementFormDefault="qualified" 
			targetNamespace="https://www.w3schools.com" 
			xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xs:annotation>
		<xs:documentation>
			Сводная схема по хабам
		</xs:documentation>
	</xs:annotation>

	<!-- todo Вставить элементы из сгенерированных XSD-схем -->
	<!-- Начало вставки -->

	<xs:element name="AirLine_Codes">
		<xs:complexType>
			<xs:sequence>
				<xs:element maxOccurs="unbounded" name="Hub">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="AirPort_FK_IATA">
								<xs:complexType>
									<xs:simpleContent>
										<!-- откидываем пробелы в начале и в конце, переводы строк, табуляции -->
										<xs:extension base="xs:token">
											<xs:attribute name="enabled" type="xs:boolean" use="required" />
										</xs:extension>
									</xs:simpleContent>
								</xs:complexType>
							</xs:element>
							<xs:element name="AirPort_FK_ICAO">
								<xs:complexType>
									<xs:simpleContent>
										<!-- откидываем пробелы в начале и в конце, переводы строк, табуляции -->
										<xs:extension base="xs:token">
											<xs:attribute name="enabled" type="xs:boolean" use="required" />
										</xs:extension>
									</xs:simpleContent>
								</xs:complexType>
							</xs:element>
						</xs:sequence>
					</xs:complexType>
				</xs:element>
			</xs:sequence>
		</xs:complexType>
	</xs:element>

	<!-- Окончание вставки -->

</xs:schema>

<!-- Окончание вставки сводной XSD-схемы -->
'

PRINT 'Создана коллекция схем XSD - dbo.SchemaHubs_Simple'
GO
