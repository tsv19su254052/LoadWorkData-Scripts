import module namespace schematron = "http://github.com/Schematron/schematron-basex";

let $sch := schematron:compile(doc('rules.sch'))
let $svrl := schematron:validate(doc('document.xml'), $sch)

return (
  schematron:is-valid($svrl),
  for $message in schematron:messages($svrl)
  return concat(schematron:message-level($message), ': ', schematron:message-description($message))
)
