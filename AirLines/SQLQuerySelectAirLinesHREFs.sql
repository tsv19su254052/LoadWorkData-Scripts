DECLARE @x XML

SELECT @x = c
FROM OPENROWSET(BULK 'AirLine_hrefs_LH_GEC_XMLSource.xml', SINGLE_BLOB) AS XX(c)

SELECT @x
