;(load "3.53-62-stream-operations.scm")

; from ch3.scm
(define fibs
  (cons-stream 0
               (cons-stream 1
                            (add-streams (stream-cdr fibs)
                                         fibs))))
                                         



(define adder

    (let ((counter 0))

        (define add        
            (lambda (x y)
                (set! counter (+ counter 1))
                (display "\nadd call #") (display counter)
                (+ x y)
            )
        )
        
        (define (reset!)
            (set! counter 0))
            
        (define (dispatch m)
            (cond
                ((eq? m 'add) add)
                ((eq? m 'reset!) (reset!))
                (else
                    (error "Unknown command -- ADDER" m))
            )
        )
        dispatch
    )
)
        
;(define add (adder 'add))        
                    

                    
; tweaked to fit my twisted evil purposes
(define (add-streams s1 s2)



    ; oh this is too HIGH level. need to know NUMBER OF ADDITIONS, since one call to add-streams makes INFINITE promises
    ;; is THIS how you hack a stupid state variable into this god forsaken language??
    ;(define adder
    ;    (let ((counter 0))
    ;        (lambda (x y) 
    ;            (set! counter (+ counter 1))
    ;            (display "\n\tadd-streams call #") (display counter)(newline)
    ;            (add-streams s1 s2)
    ;        )
    ;    )
    ;)
    ;        
    ;(adder s1 s2)
    

    
    (stream-map (adder 'add) s1 s2)  ; instead of +
)


(define (test n)
    (adder 'reset!)
    (define (iter i)
        (if (< i n)
            (begin
                (let ((result (stream-ref fibs i)))
                    (display "\tFib ") (display i) (display ": ") (display result)
                )
                (iter (+ i 1))
            )
            'done
        )
    )
    (iter 0)
)

;(test 100)
; empirical observation: if you define 0 as the 0th fibonacci number, 
    ; then you need max(0, n-1) additions to compute the nth fibonacci number.
; theoretical justification
    ; uh, all previous results are memoized...
    
; without memoization, uh, going back to the definition of N-STREAM stream-map
; (define (stream-map-3.50 proc . argstreams)
;   (if (stream-null? (car argstreams))                    
;       the-empty-stream
;       (cons-stream                                       
;        (apply proc (map car argstreams))                 
;        (apply stream-map
;               (cons proc (map stream-cdr argstreams))))))

    
; i think it's clearer going back to the table on p. 329?
    ; no, not quite, since you can't think of the streams as just 2 immutable lists anymore...



; so does it all come down to how the recursion will play out?
;                           (add-streams (stream-cdr fibs)
;                                        fibs))))

; third term of fibs = (stream-ref fibs 2)
    ; forces first term of (add-streams (stream-cdr fibs) fibs)
        ; first term of fibs is known to be 0
        ; first term of (stream-cdr fibs) is known to be 1
        ; adds to 1.
; fourth term of fibs = (stream-ref fibs 3)
    ; forces SECOND term of (add-streams (stream-cdr fibs) fibs)
        ; RE-EVALUATES first term, which is 1 extra addition
        ; second term of fibs is known to be 0
        ; ** RE-EVALUATE ** second term of (stream-cdr fibs), which is the (stream-ref fibs 2) - 1 extra addition
        ; total 2 extra additions
; (stream-ref fibs 4)
    ; forces THIRD term of (add-streams (stream-cdr fibs) fibs)
        ; third term of fibs = (stream-ref fibs 2) - 1 extra addition
        ; third term of (stream-cdr fibs) - 2 extra additions
        ; total 3 additions
        
        ; so the number of extra unnecessary additions is ITSELF a fibonacci number
        ; this grows exponentially - Exercise 1.13.


    
    
    
; is there any way to implement the non-memoized delay? bleh.
; (define (stream-map-v2 proc s)
;   (if (stream-null? s)
;       the-empty-stream
;       (cons                                         ; (cons-stream <a> <b>)  is equivalent to (cons <a> (delay <b>))
;         (proc (car s))
;         (lambda () (stream-map-v2 proc (cdr s)))    ; (delay <exp>) is syntactic sugar for (lambda () <exp>)
;       )
;   )
; )