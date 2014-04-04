; meh just copy exercise 3.17

; also, exercise 3.19 implies that the non-clever version will NOT use a constant amount of space.

; things are MUCH easier because we only want to know whether successive cdr will cause an infinite loop
    ; we don't WORRY about whether car will lead to lists too
(define (is-cycle? x)

    (define (in-history? pair history)
        (memq pair history))

    (define (iter L history)    
        (cond
            ((or (null? L) (not (pair? L)))
                false)
            ((in-history? L history)        ; NOT (car L)!
                true)  
            (else

                (iter 
                    (cdr L)
                    (append history (list L))   ; (append history L) is NOT right!
                )
            )
        )
    )
    
    (iter x '())
)





(define (test-3.18-19)

    (newline) (display (is-cycle? '(1 2)))  ; #f, phew

    ; from exercise 3.13
    (define (test L)
        (set-cdr! (last-pair L) L)  ; FORCE a cyclic list
        (display "\nNow this is either gonna give #t or hang forever... ")
        (display (is-cycle? L))   ; #t or infinite loop
        
        (display "\nand now the cheap check: ") (display (not (list? L)))   ; a cyclic list will never hit null
    )                                                                       ; realized this when i tried (length

    (test '(1 2))
    (test '(3 4 4))
    (test '(3 (4 5) 548 (3 3 (2))))
)
;(test-3.18-19) 

; see sols for some REAL algorithms