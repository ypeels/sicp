(load "5.33-38-compiling-to-file.scm")



; cf p. 591
; (compile expr 'val 'next) is unreadable! just a gigantic list of instructions
(compile-to-file
    '(define (f x) (+ x (g (+ x 2))))   ; my answer from the asm reading
    'val
    'next
    "5.35-decompiling-figure-5-18.txt"
)
; the result is identical to Figure 5.18, except for label numbers
    ; i can only presume that their label numbering comes from the fact that this was a subexpression?



(display "\ngoodbye world - never gets here?")
