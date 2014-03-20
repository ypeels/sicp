; REEEEAL devious, introducing such important procedures in an EXERCISE...
; - (newline)
; - (display) ; which can be called BEFORE a return "statement"!
; - (runtime)



; my work
(define (search-for-primes search-min search-max)
    (cond
    
        ; odd numbers only, for my convenience
        ((= 0 (remainder search-min 2)) 
            (search-for-primes (+ search-min 1) search-max))
    
        ; termination
        ((> search-min search-max) (newline))
        
        (else
            
            ; do the real work
            (timed-prime-test search-min)
            
            ; "next iteration" (next odd integer)
            (search-for-primes (+ search-min 2) search-max))))  
            


; from ch1.scm
; ----------------------------------------------------------------
;; prime?

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        ;(else (find-divisor n (+ test-divisor 1))))) ; original
        (else (find-divisor n (next-divisor test-divisor))))) ; modified for Exercise 1.23
        
 

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))
  
;;EXERCISE 1.22
(define (timed-prime-test n)
  ;(newline)
  ;(display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)      
      (report-prime n (- (runtime) start-time))))

(define (report-prime n elapsed-time)
  (display n) ; keep the display CONCISE
  (display " *** ")
  (display elapsed-time)
  (newline))
; ----------------------------------------------------------------


  






        
  

  
  
