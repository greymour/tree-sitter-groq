; extends

; GROQ injection for /* groq */ `...` pattern in TypeScript/JavaScript
;
; Installation: Copy to ~/.config/nvim/after/queries/typescript/injections.scm
;                   and ~/.config/nvim/after/queries/javascript/injections.scm

; Matches: const x = /* groq */ `...`
; AST: (variable_declarator (comment) value: (template_string (string_fragment)))
((variable_declarator
  (comment) @_groq_comment
  value: (template_string
    (string_fragment) @injection.content))
  (#lua-match? @_groq_comment "groq")
  (#set! injection.language "groq"))
