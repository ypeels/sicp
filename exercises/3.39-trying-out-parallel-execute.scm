(load "3.39-42-parallel-execute-and-serializer.scm")

(define x 10)
(define s (make-serializer))

(define (test)

   ; (set! x 10)
;    (let ((x 10) (s (make-serializer)))
    
        ; from problem statement
        (parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))    ; P1
                          (s (lambda () (set! x (+ x 1)))))                 ; P2
                          
        ;(newline) (display x)
        ;(s (lambda () (display x))) ; no effect
 ;   )
)
(test)
; (display x) ; always 10

; parallelizer isn't working?
    ; rather, the (display) works too fast? 
    ; x = 101 when queried at the interactive prompt. haven't seen another value yet...
    ; note that this needs x to be declared at global scope???

; "old" values 121 and 101 are both possible (depends on whether P1 or P2 executes first)
; "new" values: 
    ; 100 - P2 interrupts P1 after the squaring but before the set!
    ; 11 - P2 reads x before P1's set!, then overwrites P1's result


; possibilities on p. 305 ruled out:
    ; 110: P2 changes value between the 2 accesses of x in P1, but the mutex forbids that now
