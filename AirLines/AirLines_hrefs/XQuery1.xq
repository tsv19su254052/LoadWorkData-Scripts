(:~ 
 : *.xq - файл запроса в общем случае,
 : *.xqm - модуль импорта
:)

(: Берем XML-ный файл на вход :)
let $source := doc("AirLine_hrefs_LH_GEC_XMLSource.xml")

let $string := "example"
for $output in $source
(: where contains(string($string), "") :)

(: -- Выдает ошибку 
modify(
  replace value of node $output/AirLine_HREFs/hrefToSite with 'aaa'
  replace value of node $A with <D>Goodbye</D>
  
  if ($e/@last-updated)
  then replace value of node
    $e/last-updated with fn:currentDate()
  else insert node
    attribute last-updated {fn:currentDate()} into $e
  
  rename node  /AirLine_HREFs/hrefToSite as 'bbb'
  insert node /hrefToSite2 into /AirLine_HREFs
  delete nodes $output/AirLine_HREFs/hrefToSite[1]
)

let $input := doc('my-input.xml')
let $remove-list := ('xxx', 'yyy', 'zzz')
local:remove-elements($input,  $remove-list) 
:)

return (
  $output/AirLine_HREFs,
  (: нумерация веток и подветок начинается с "1" :)
  $output/AirLine_HREFs/hrefToSite
)
