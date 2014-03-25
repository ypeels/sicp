; come on lucky 7
; (newline) (display 
;     (car
;         (cdr                                ; (7)
;             (car                            ; (5 7)
;                 (cdr (cdr (1 3 (5 7) 9)))   ; ((5 7) 9)
;             )
;         )
;     )
; )


(define (apply-operations operation-list tree)
    (newline)
    (display tree)
    (if (null? operation-list)
        tree
        (apply-operations 
            (cdr operation-list)
            ((car operation-list) tree)
        )
    )

    ;(if (null? 
    ;(cond 
    ;    ((null? operation-list) (display "\nthat's all folks\n"))
    ;    (else
    ;
    ;        (apply-operations 
    ;            (cdr operation-list)
    ;            ((car operation-list) tree)
    ;        )
    ;    )
    ;)
)

; (car (cdr (car (cdr (cdr L )))))
(define L1 (list 1 3 (list 5 7) 9))
(apply-operations (reverse (list car cdr car cdr cdr)) L1) (newline)
(display (car (cdr (car (cdr (cdr L1 )))))) (newline)

; (car (car L))
;(newline)
;(if (not (= 7 (apply-operations (list car car) (list (list 7)))))
;    (error "how'd you mess up the easiest one?")
;    (display "\n((7)) ok\n"))
(apply-operations (list car car) (list (list 7)))

; (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr
; ugh, it takes (car (cdr)) to get to a nested list
(define L3 (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
(apply-operations
    (reverse (list car cdr car cdr car cdr car cdr car cdr car cdr))                              
    L3
)
(newline)
(display (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr L3)))))))))))))



; the moral?
; tree construction is awkward, even with (list)
; tree traversal is VERY awkward, using (car)/(cdr)...
            