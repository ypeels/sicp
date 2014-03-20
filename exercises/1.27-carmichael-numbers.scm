; if fermat test FAILS then return false
; else test on the next integer

(load "1.22-24-display-and-newline.scm") ; for prime? just for completeness...
(define (next-divisor n) (+ n 1)) ; meh, screw performance for this exercise

(load "1.24-25-fast-prime-by-fermat.scm") ; still need this for (expmod). maybe i should just (load "ch1.scm")??



(define (passes-fermat-test? n)

    (define (iter a n)
        (cond
            
            ((>= a n) #t)                   ; final termination: passed all the way through
            
            ((= (expmod a n n) a)           ; passed the main test for this iteration
                (iter (+ a 1) n))
                
            (else #f)))                     ; early termination: failed the main test
            
    
    
    (iter 1 n))                             ; technically, a = 1 and a = (n-1) both pass the Fermat test trivially...meh.
    

    
(define (carmichael n)
    (display n)
    (display " *** ")
    (display 
        (if (prime? n)
            " is prime!"
            " is not prime..."))      ; wow, if and else cases are RIGHT next to each other...
    (display 
        (if (passes-fermat-test? n)
            " passed EXHAUSTIVE Fermat test!"
            " failed Fermat test."))
    (newline))
            
        
    
        
    
        
    
    
(newline)                                   ; stupid scheme interpreter
(carmichael 561)                            ; footnote 47
(carmichael 1105)
(carmichael 1729)
(carmichael 2465)
(carmichael 2821)
(carmichael 6601)


; (search-for-primes 500 1000) ; now these actually ARE prime
(carmichael 751)
(carmichael 997)