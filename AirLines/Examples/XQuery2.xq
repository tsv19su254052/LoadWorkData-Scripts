(:module namespace basex = "http://basex.org";:)
(:module namespace input = "http://basex.org/modules/input";:)

(: -- Выдает ошибку 
<p>See <a href="index.html"><i>here</i></a> for info.</p>
:)

let $i := 2 return
let $r := <em>Value </em>

(: -- Выдает ошибку 
let $a := 3, 4
:)
let $b := ($a, $a)
let $c := 99
let $d := ()

(: -- Выдает ошибку 
children(<p>This is <em>very</em> cool.</p>)
:)

for $x in (1 to 3) return ($x, 10+$x)

for $keyword at $i in ("car", "skateboard", "canoe"),
    $parent in doc("part-tree.xml")//part[@name=$keyword]
let $descendants := $parent//part
for $p in ($parent, $descendants)
return 
  replace value of node $p/@partid with $i*1000+$p/@partid

return (
  count($a), count($b), count($c), count($d)), 
  <p>{$r} of 10*{$i} is {10*$i}.</p>
)
