(define p (cons 1 2))
(set-car! p 3)                  ; similarly set-cdr!
(newline) (display p) ; (3 . 2)

; Footnote 18: "Get-new-pair is one of the operations that must be implemented as part of the memory 
;   management required by a Lisp implementation."
(get-new-pair)  ; Unbound variable: get-new-pair