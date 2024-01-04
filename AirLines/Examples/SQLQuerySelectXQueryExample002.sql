-- DECLARE @xml_edi XML  = '<Bundle><RawData>ABCDE&amp;#x1E;&amp;#x1C;FGHIJK&amp;#x1D;LMNOP</RawData></Bundle>' 
-- SELECT x.y.value('./RawData[1]','varchar(max)')
-- from @xml_edi.nodes('/Bundle')x(y)

DECLARE @xml_edi XML  = '<Bundle><RawData>ABCDE&amp;#x1E;&amp;#x1C;FGHIJK&amp;#x1D;LMNOP</RawData></Bundle>' 
--nested replace
SELECT REPLACE(REPLACE(REPLACE(REPLACE(x.y.value('./RawData[1]','nvarchar(max)'),'&#x1C;',CHAR(28)),'&#x1D;',CHAR(29)),'&#x1E;', char(30)),'&#x1F;',CHAR(31))
from @xml_edi.nodes('/Bundle')x(y)
--nested replace; cleaner?
SELECT 
    s.Colors
FROM
    (SELECT x.y.value('./RawData[1]','nvarchar(max)') AS Colors FROM @xml_edi.nodes('/Bundle')x(y) ) c
    CROSS APPLY (SELECT REPLACE(c.Colors,'&#x1C;',CHAR(28)) AS Colors) r
    CROSS APPLY (SELECT REPLACE(r.Colors,'&#x1D;',CHAR(29)) AS Colors) g
    CROSS APPLY (SELECT REPLACE(g.Colors,'&#x1E;',CHAR(30)) AS Colors) b
    CROSS APPLY (SELECT REPLACE(b.Colors,'&#x1F;',CHAR(31)) AS Colors) s
