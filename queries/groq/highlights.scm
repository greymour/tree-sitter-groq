; Keywords
[
  "in"
  "match"
  "asc"
  "desc"
] @keyword

; Operators
[
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
  "&&"
  "||"
  "!"
] @keyword.operator

[
  "+"
  "-"
  "*"
  "/"
  "%"
  "**"
] @operator

[
  "|"
  "->"
  "=>"
  ".."
  "..."
  "."
] @punctuation.special

; Punctuation
[
  "("
  ")"
] @punctuation.bracket

[
  "["
  "]"
] @punctuation.bracket

[
  "{"
  "}"
] @punctuation.bracket

[
  ","
  ":"
] @punctuation.delimiter

; Literals
(null) @constant.builtin
(true) @boolean
(false) @boolean
(number) @number

; Strings
(string) @string
(escape_sequence) @string.escape

; Comments
(comment) @comment @spell

; Variables (parameters like $myVar)
(variable) @variable.parameter

; Special references
(this) @variable.builtin
(parent) @variable.builtin
(everything) @variable.builtin

; Identifiers (default)
(identifier) @variable

; Function calls
(function_call
  name: (identifier) @function.call)

; Built-in functions get special highlighting
(function_call
  name: (identifier) @function.builtin
  (#any-of? @function.builtin
    "count" "defined" "length" "references" "path"
    "coalesce" "select" "order" "score" "boost"
    "now" "identity" "lower" "upper" "round"
    "string" "dateTime" "geo" "global" "pt"))

; Property access
(access_expression
  member: (identifier) @variable.member)

(dereference_expression
  member: (identifier) @variable.member)

; Projection/object keys
(projection_pair
  key: (identifier) @variable.member)

(projection_pair
  key: (string) @string)

(object_pair
  key: (identifier) @variable.member)

(object_pair
  key: (string) @string)

; Spread operator
(spread
  "..." @punctuation.special)
