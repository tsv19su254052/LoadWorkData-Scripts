USE AirFlightsDBNew62
GO

-- � �������� �������� ���������� ����� �� ����� *.xsd
CREATE XML SCHEMA COLLECTION SchemaCollectionXsdFull AS '
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns:ns="https://www.w3schools.com"
			xmlns:xml="http://www.w3.org/XML/1998/namespace"
			xmlns:fn="http://www.w3.org/2004/07/xpath-functions"
			xmlns:sqltypes="https://schemas.microsoft.com/sqlserver/2004/sqltypes"
			xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
			xmlns:soap="https://schemas.microsoft.com/sqlserver/2004/SOAP"
			xmlns:ms="urn:schemas-microsoft-com:mapping-schema"
			xmlns:dt="urn:schemas-microsoft-com:datatypes"
			xmlns:sql="urn:schemas-microsoft-com:xml-sql">
	<!-- t (������ �� ��������� ����� "targetNamespace"), xsd, xsi, ns - �������� ������������ ���� (������� ���������� ������ �� URI) -->
	<xsd:annotation>
		<xsd:documentation>
			��� ����� XSD ������
		</xsd:documentation>
	</xsd:annotation>

	<xsd:element name="AirCraftRegistrationXML">
		<xsd:complexType>
			<!-- ������ ������ ���� "AirCraftRegistrationXML"-->
			<xsd:sequence maxOccurs="unbounded">
				<xsd:element name="step">
					<xsd:complexType>
						<!-- ������ ������ ������� "step"-->
						<xsd:sequence maxOccurs="unbounded">
							<xsd:element name="BeginDate" type="xsd:date" />
						</xsd:sequence>
						<xsd:attribute name="AirCraftRegistrationFK" type="xsd:string" />
					</xsd:complexType>
				</xsd:element>
			</xsd:sequence>
		</xsd:complexType>
	</xsd:element>

	<xsd:element name="AirLineOperatorXML">
		<xsd:complexType>
			<xsd:sequence maxOccurs="unbounded">
				<xsd:element name="step">
					<xsd:complexType>
						<xsd:sequence maxOccurs="unbounded">
							<xsd:element name="BeginDate" type="xsd:date" />
						</xsd:sequence>
						<xsd:attribute name="AirLineOperatorFK" type="xsd:unsignedLong" />
					</xsd:complexType>
				</xsd:element>
			</xsd:sequence>
		</xsd:complexType>
	</xsd:element>

	<xsd:element name="AirLineOwnerXML">
		<xsd:complexType>
			<xsd:sequence maxOccurs="unbounded">
				<xsd:element name="step">
					<xsd:complexType>
						<xsd:sequence maxOccurs="unbounded">
							<xsd:element name="BeginDate" type="xsd:date" />
						</xsd:sequence>
						<xsd:attribute name="AirLineOwnerFK" type="xsd:unsignedLong" />
					</xsd:complexType>
				</xsd:element>
			</xsd:sequence>
		</xsd:complexType>
	</xsd:element>

	<xsd:element name="AirLineLandLordXML">
		<xsd:complexType>
			<xsd:sequence maxOccurs="unbounded">
				<xsd:element name="step">
					<xsd:complexType>
						<xsd:sequence maxOccurs="unbounded">
							<xsd:element name="BeginDate" type="xsd:date" />
						</xsd:sequence>
						<xsd:attribute name="AirLineLandLordFK" type="xsd:unsignedLong" />
					</xsd:complexType>
				</xsd:element>
			</xsd:sequence>
		</xsd:complexType>
	</xsd:element>

	<xsd:element name="AirLineLessorXML">
		<xsd:complexType>
			<xsd:sequence maxOccurs="unbounded">
				<xsd:element name="step">
					<xsd:complexType>
						<xsd:sequence maxOccurs="unbounded">
							<xsd:element name="BeginDate" type="xsd:date" />
						</xsd:sequence>
						<xsd:attribute name="AirLineLessorFK" type="xsd:unsignedLong" />
					</xsd:complexType>
				</xsd:element>
			</xsd:sequence>
		</xsd:complexType>
	</xsd:element>

</xsd:schema>'

PRINT '������� ��������� ���� XSD - dbo.SchemaCollectionXsdFull'
GO
