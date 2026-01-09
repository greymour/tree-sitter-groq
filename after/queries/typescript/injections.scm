; extends

; GROQ injection for TypeScript/JavaScript
;
; Installation: Copy to ~/.config/nvim/after/queries/typescript/injections.scm
;                   and ~/.config/nvim/after/queries/javascript/injections.scm

; =============================================================================
; Pattern 1: const x = /* groq */ `...`
; =============================================================================
((variable_declarator
  (comment) @_groq_comment
  value: (template_string
    (string_fragment) @injection.content))
  (#lua-match? @_groq_comment "groq")
  (#set! injection.language "groq"))

; =============================================================================
; Pattern 2: defineQuery(`...`)
; =============================================================================
((call_expression
  function: (identifier) @_fn
  arguments: (arguments
    (template_string
      (string_fragment) @injection.content)))
  (#eq? @_fn "defineQuery")
  (#set! injection.language "groq"))

; =============================================================================
; Pattern 3: groq`...` (tagged template literal)
; =============================================================================
((call_expression
  function: (identifier) @_fn
  arguments: (template_string
    (string_fragment) @injection.content))
  (#eq? @_fn "groq")
  (#set! injection.language "groq"))
