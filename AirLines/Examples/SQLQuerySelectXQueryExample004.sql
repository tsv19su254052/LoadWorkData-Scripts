DECLARE @xml_edi XML  = '<Bundle><RawData>ABCDE&amp;#x1E;&amp;#x1C;FGHIJK&amp;#x1D;LMNOP</RawData></Bundle>';

WITH EscapedStrings AS(
    SELECT x.b.value('(./RawData/text())[1]','varchar(max)') AS EscapedString
    FROM @xml_edi.nodes('/Bundle')x(b)),
Groups AS (
    SELECT ES.EscapedString,
           SS.C,
           GS.Value,
           COUNT(CASE SS.C WHEN '&' THEN 1 END) OVER (PARTITION BY ES.EscapedString ORDER BY GS.Value
                                                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) + 
           COUNT(CASE SS.C WHEN ';' THEN 1 END) OVER (PARTITION BY ES.EscapedString ORDER BY GS.Value
                                                      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS Grp
    FROM EscapedStrings ES
         CROSS APPLY GENERATE_SERIES(CONVERT(bigint,1),LEN(ES.EscapedString),CONVERT(bigint,1)) GS
         CROSS APPLY (VALUES(CONVERT(char(1),SUBSTRING(ES.EscapedString,GS.value,1))))SS(C)),
EscapeGroups AS (
    SELECT G.EscapedString,
           G.C,
           G.Grp,
           G.Value,
           COUNT(CASE G.C WHEN ';' THEN 1 END) OVER (PARTITION BY G.EscapedString, G.Grp) AS EscapeGroup
    FROM Groups G)
SELECT CONVERT(varchar(MAX),CONVERT(varbinary(MAX),STRING_AGG(CASE EG.EscapeGroup WHEN 1 THEN EG.C
                                                                                  ELSE CONVERT(varchar(2),CONVERT(varbinary(1),EG.C),2)
                                                              END,'') WITHIN GROUP (ORDER BY EG.Value),2))
FROM EscapeGroups EG
WHERE NOT (EG.EscapeGroup = 1 AND EG.C IN ('&','#','x',';'))
GROUP BY EG.EscapedString
