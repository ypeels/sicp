; meh just copy exercise 3.17

; also, exercise 3.19 implies that the non-clever version will NOT use a constant amount of space.

; things are MUCH easier because we only want to know whether successive cdr will cause an infinite loop
    ; we don't WORRY about whether car will lead to lists too
(define history '())

(define (in-history? pair)
    (memq pair history)) 
    
(define (add-to-history! x)
    (if (null? history)
        (set! history (list x)) 
        (append! history (list x))
    )
)

(define (is-cycle? x)

    ; wait, the cyclic list was handled FINE by exercise 3.17... is this just not doable by an internal, iterative history??
    ;(define (in-history? pair history)
    ;    ;(newline)(display history)
    ;    (memq pair history))


    ;(define (iter L history)
    ;
    ;    (cond
    ;        ((or (null? L) (not (pair? L)))
    ;            false)
    ;        ((in-history? L history)        ; NOT (car L)!
    ;            true)  
    ;        (else
    ;            (newline) (display history)
    ;            (iter 
    ;                (cdr L)
    ;                (append history L)
    ;            )
    ;        )
    ;    )
    ;)
    ;
    ;(iter x '())
    
    ; adapted from Exercise 3.17
    (cond
        ((null? x)     
            false)
        ((in-history? x)
            true)  
        (else
            (add-to-history! x)
            (is-cycle? (cdr x))
        )
    )
)



;(display (car x)) (display (cadr x)) (display (caddr x))

(define (test-3.18)

    (newline) (display (is-cycle? '(1 2)))  ; #f, phew

    ; from exercise 3.13
    (define (test L)
        (set-cdr! (last-pair L) L)  ; FORCE a cyclic list
        (display "\nNow this is either gonna give #t or hang forever... ")
        (display (is-cycle? L))   ; #f or infinite loop
    )

    (test '(1 2))
    (test '(3 4 4))
    (test '(3 (4 5) 548 (3 3 (2))))
)
(test-3.18)