; thus begins a series of exercises that i DON'T think we have any easy way of testing...
; i guess i'll just have to check vs http://community.schemewiki.org/?sicp-solutions


; Exercise 2.44
; Define the procedure up-split used by corner-split. 
; It is similar to right-split, except that it switches the roles of below and beside. 
;(define (right-split painter n)
;  (if (= n 0)
;      painter
;      (let ((smaller (right-split painter (- n 1))))
;        (beside painter (below smaller smaller)))))


; proceeding strictly by analogy...
(define (up-split painter n)
    (if (= n 0)
        painter
        (let ((smaller ((up-split painter (- n 1)))))
            (below painter (beside smaller smaller)))))
    
    
; http://community.schemewiki.org/?sicp-ex-2.44
    ; "I am really uncomfortable writing code that I can't run"