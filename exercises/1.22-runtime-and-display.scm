; REEEEAL devious, introducing such important procedures in an EXERCISE...
; - (newline)
; - (display) ; which can be called BEFORE a return "statement"!
; - (runtime)


; from ch1.scm
; ---------------------------------------------
;; prime?

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

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
; --------------------------------------------- 


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



(newline) ; pass the scheme interpreter startup junk
; not sure how to stop after only 3 primes, so i'll just guess at ranges            
;(search-for-primes 1000 1030)
; 1009 *** 0.
; 1013 *** 0.
; 1019 *** 0.
; 1021 *** 0. my 2010 Intel Core i7-870 is TOO FAST for this
; ...

;(search-for-primes 10000 10040)
; 10009 *** 0.
; 10037 *** 0.
; 10039 *** 0.

;(search-for-primes 100000 100050)
; 100003 *** 0.
; 100019 *** 0.
; 100043 *** 0.

;(search-for-primes 1000000 1000040)
; 1000003 *** 0.
; 1000033 *** 0.
; 1000037 *** 0.

;(search-for-primes 10000000 10000105)
; still not consistently nonzero

(search-for-primes 100000000 100000040)
; 100000007 *** .016
; 100000037 *** .016
; 100000039 *** .031
; average runtime ~0.021


(search-for-primes 1000000000 1000000090)
; 1000000007 *** .063
; 1000000009 *** .078
; 1000000021 *** .063
; 1000000033 *** .078
; average runtime ~0.075
; runtime increased by factor of ~3.6

(search-for-primes 10000000000 10000000090)
; 10000000019 *** .234
; 10000000033 *** .219
; 10000000061 *** .219
; average runtime ~0.224
; runtime increased by factor of ~3

; sqrt(10) ~ 3.16
; that's PRETTY CLOSE to the empirically observed order of growth in runtime!





        
  

  
  
