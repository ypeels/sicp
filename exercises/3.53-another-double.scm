(load "3.53-62-stream-operations.scm")

; from problem statement
(define s (cons-stream 1 (add-streams s s)))

; my guess: this is an alternate way to express 2**n.
; an annoying thing you have to wrap your brain around is that each "add-stream" only evaluates ONE member?
(newline) (display (stream-ref s 0))    ; 1
(newline) (display (stream-ref s 1))    ; 2
(newline) (display (stream-ref s 2))    ; 4
(newline) (display (stream-ref s 3))    ; 8
(newline) (display (stream-ref s 4))    ; 16 yep.