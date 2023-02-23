USE AirLinesDBNew62
GO

-- � �������� �������� ���������� ����� �� ����� *.xsd
-- ����� �������� ��������� ����
CREATE XML SCHEMA COLLECTION SchemaHubs AS '
<!-- ������ ������� ������� XSD-����� -->

<!-- ������ ������� �������� ����������� ����, todo ��������� ����� �� ��������������� XSD-����� -->
<xs:schema attributeFormDefault="unqualified"
			elementFormDefault="qualified"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:ns="https://www.w3schools.com"
			targetNamespace="https://www.w3schools.com"
			xsi:schemaLocation=""
			xsi:noNamespaceSchemaLocation=""
			xmlns:xml="http://www.w3.org/XML/1998/namespace"
			xmlns:fn="http://www.w3.org/2004/07/xpath-functions"
			xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
			xmlns:xlink="http://www.w3.org/1999/xlink"
			xmlns:xi="http://www.w3.org/2001/XInclude"
			xmlns:css="http://www.w3.org/1996/css"
			xmlns:collation="http://www.w3.org/2013/collation/UCA?strength=secondary"
			xmlns:xsv="http://www.w3.org/2007/XMLSchema-versioning"
			xmlns:xproc="http://www.w3.org/ns/xproc"
			xmlns:xproc-step="http://www.w3.org/ns/xproc-step"
			xmlns:err="http://www.w3.org/ns/xproc-error"
			xmlns:xhtml="http://www.w3.org/1999/xhtml"
			xmlns:p="http://www.w3.org/1999/XSL/Transform"
			xmlns:sqltypes="https://schemas.microsoft.com/sqlserver/2004/sqltypes"
			xmlns:soap="https://schemas.microsoft.com/sqlserver/2004/SOAP"
			xmlns:ms="urn:schemas-microsoft-com:mapping-schema"
			xmlns:dt="urn:schemas-microsoft-com:datatypes"
			xmlns:sql="urn:schemas-microsoft-com:xml-sql"
			xmlns:soapex="http://schemas.xmlsoap.org/soap/envelope"
			xmlns:saxon="http://saxon.sf.net"
			xmlns:schematron="http://purl.oclc.org/dsdl/schematron"
			xmlns:set="http://transpect.io/xml2tex"
			xmlns:tr="http://transpect.io"
			xmlns:pxf="http://exproc.org/proposed/steps/file"
			xmlns:rng="http://relaxng.org/ns/structure/1.0"
			xmlns:rnga="http://relaxng.org/ns/compatibility/annotations/1.0">

	<!--  the following imports are not needed. They simply provide readability  -->
	<xs:import namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord"/>
	<xs:import namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"/>

	<xs:annotation>
		<xs:documentation>
			������� ����� �� �����
		</xs:documentation>
		<p:documentation p="http://www.w3.org/1999/xhtml">
			==== ������ ������� ����� ====
			<p:import href="epubcheck-command-line.xpl"/>
			==== ������ ������� ������ ====
			<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
			<p:import href="http://transpect.io/calabash-extensions/epubcheck-extension/epubcheck-declaration.xpl"/>
			<p:import href="http://transpect.io/xproc-util/file-uri/xpl/file-uri.xpl"/>
			<p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>
			<p:import href="http://transpect.io/xproc-util/simple-progress-msg/xpl/simple-progress-msg.xpl"/>
			==== ������� �������� ====
			<p:document href="http://this.transpect.io/xmlcatalog/catalog.xml"/>
		</p:documentation>
	</xs:annotation>

	<!-- todo �������� �������� �� ��������������� XSD-���� -->
	<!-- ������ ������� -->

	<xs:element name="AirLine_Codes">
		<xs:complexType>
			<xs:sequence>
				<xs:element maxOccurs="unbounded" name="step">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="AirPort_FK_IATA" type="xs:string" />
							<xs:element name="AirPort_FK_ICAO" type="xs:string" />
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

PRINT '������� ��������� ���� XSD - dbo.SchemaHubs'
GO
