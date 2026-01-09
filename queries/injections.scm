; This file defines how GROQ can be injected into other languages
; For JS/TS files, the injection query goes in the JS/TS grammar config
; This file is for reference and for editors that support it

; Strings containing GROQ (when explicitly marked)
((comment) @injection.content
  (#set! injection.language "groq"))
