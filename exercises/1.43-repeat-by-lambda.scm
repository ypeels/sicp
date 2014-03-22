; Hint: You may find it convenient to use compose from exercise 1.42. 
(load "1.42-composition-by-lambda.scm")

; no need to ASSUME n is an integer - just ERROR-CHECK it
; first pass:
; use a RECURSIVE process because that's simpler? (and i'm not QUITE sure how to do this iteratively)
; use a SIMPLE algorithm to make sure it works (the problem didn't say to use the fast-squaring algorithm)
; write tests, then try new implementations and see if tests still pass.

(define (repeated foo n)

    (cond
        ((not (integer? n)) (error "n is not an integer" n))    ;(error) from 1.3.3, (integer?) from google search
        ((<= n 0)           (lambda (x) x))                     ; null value is the identity operation.
        (else               (compose foo (repeated foo (- n 1))))))
        
        
(define (repeated-iter foo n)

    (define (iter n result)
        (if (<= n 0)
            result
            (iter (- n 1) (compose foo result))))   ; will this work??
    

    (if (not (integer? n))
        (error "n is not an integer" n)
        (iter n (lambda(x) x))))
        
        
; by analogy with (fast-expt)
(define (even? n) (= 0 (remainder n 2)))
(define (fast-repeated foo n)

    ; need to define "squaring" operation
    (define (double f) (lambda (x) (f (f x))))

    (cond   ((= n 0) (lambda (x) x))                                    ; termination: null value is the identity operation.
            ((even? n) (double (fast-repeated foo (/ n 2))))            ; (double) is analogous to squaring
            (else (compose foo (fast-repeated foo (- n 1))))            ; (compose) is analogous to multiplying
    )                                                                   ; and no confusing lambdas! functions are FIRST-CLASS CITIZENS!!!    
)
            
            
; how about analogy with (fast-expt-iter)?? copy/pasted it and then modified accordingly
; NO NEED to worry about returning functions as lambdas, since they're FIRST-CLASS
(define (fast-repeated-iter foo reps)  

    (define (double f) (lambda (x) (f (f x))))

    (define (iter a b n)
        (cond 
        
            ; "loop termination"         
            ((<= n 0) (lambda (x) (a x)))        
        
            ((even? n)                
                (iter           
                    a                                   ; a = a                    
                    (double b)                          ; (square b)  ; b = b**2
                    ;(lambda (x) (double (b x)))        ; does NOT work!? "compount-procedure". not sure why...
                    (/ n 2)))                           ; n = n/2
                    
            (else  ; n is odd
                (iter
                    (compose a b)                       ; (* a b)     ; a = a*b
                    b                                   ; b = b
                    (- n 1)))))                         ; n = n-1
              
           
    (iter 
        (lambda (x) x)      ; null value
        foo                 ; base        
        reps                ; exponent
    )
)
        
        
        
        
            
        

            


(define (test-1.43)

    ; aha, you can reimplement double this way
    (define (inc x) (+ x 1))
    (define (double foo) (repeated foo 2))
    
    (newline) (display "reimplementing double")
    (newline) (display ((double inc) 5))                      ; should be 7
    (newline) (display (((double double) inc) 5))             ; should be 9
    (newline) (display (((double (double double)) inc) 5))    ; should be 21
    (newline)

    ;(display "\nbare invocations - stupid scheme")
    ;(display "\nrecursive simple: ")
    ;(display ((repeated square 2) 5))
    ;(display "\niterative simple: ")
    ;(display ((repeated-iter square 2) 5))  ; should both be 625
    ; (newline) (define R repeated) (display ((R square 2) 5)) ; this works fine too...
    
    
    (define (test-repeat-square repeat name reps base)        
        (newline) 
        (display name) (display ": ")
        (display ((repeat square reps) base))
        
        ;(display (fast-expt-iterative 2 reps))
    )
    
    (define (test reps base)
        (load "1.16-fast-expt-iter.scm")
        (newline) (display base) (display "^(2^") (display reps) (display ")")
        (test-repeat-square repeated "recursive naive" reps base)
        (test-repeat-square repeated-iter "iterative naive" reps base)
        (test-repeat-square fast-repeated "recursive by squaring the repeat operation" reps base)
        (test-repeat-square fast-repeated-iter "ITERATIVE by squaring the repeat operation" reps base)
        (display "\nexact: ")
        (display (fast-expt-iterative base (fast-expt-iterative 2 reps))))
        
    
    ; this works fine!! i just had the wires for "reps" and "base" crossed in the invocation for a while
    ;(test 0 7)
    ;(test 1 7) ; mainly for debugging the stupid turgid syntax...
    (test 2 5)
    (test 3 3)
    (test 4 2)
    

)

(test-1.43)