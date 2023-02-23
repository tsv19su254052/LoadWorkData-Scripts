USE AirLinesDBNew62
GO

-- � �������� �������� ���������� ����� �� ����� *.xsd
CREATE XML SCHEMA COLLECTION SchemaHubs_Simple AS '
<!-- ������ ������� ������� XSD-����� -->

<!-- ������ ������� �������� ����������� ����, todo ��������� ����� �� ��������������� XSD-����� -->
<xs:schema  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			attributeFormDefault="unqualified" 
			elementFormDefault="qualified" 
			targetNamespace="https://www.w3schools.com" 
			xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xs:annotation>
		<xs:documentation>
			������� ����� �� �����
		</xs:documentation>
	</xs:annotation>

	<!-- todo �������� �������� �� ��������������� XSD-���� -->
	<!-- ������ ������� -->

	<xs:element name="AirLine_Codes">
		<xs:complexType>
			<xs:sequence>
				<xs:element maxOccurs="unbounded" name="Hub">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="AirPort_FK_IATA">
								<xs:complexType>
									<xs:simpleContent>
										<!-- ���������� ������� � ������ � � �����, �������� �����, ��������� -->
										<xs:extension base="xs:token">
											<xs:attribute name="enabled" type="xs:boolean" use="required" />
										</xs:extension>
									</xs:simpleContent>
								</xs:complexType>
							</xs:element>
							<xs:element name="AirPort_FK_ICAO">
								<xs:complexType>
									<xs:simpleContent>
										<!-- ���������� ������� � ������ � � �����, �������� �����, ��������� -->
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

	<!-- ��������� ������� -->

</xs:schema>

<!-- ��������� ������� ������� XSD-����� -->
'

PRINT '������� ��������� ���� XSD - dbo.SchemaHubs_Simple'
GO
