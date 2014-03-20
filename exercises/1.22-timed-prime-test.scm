(load "1.22-24-display-and-newline.scm")


(define (next-divisor d) (+ d 1))


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

(search-for-primes 1000000000 1000000030)
; 1000000007 *** .063
; 1000000009 *** .078
; 1000000021 *** .063
; 1000000033 *** .078
; average runtime ~0.075
; runtime increased by factor of ~3.6

(search-for-primes 10000000000 10000000065)
; 10000000019 *** .234
; 10000000033 *** .219
; 10000000061 *** .219
; average runtime ~0.224
; runtime increased by factor of ~3

(search-for-primes 100000000000 100000000060)
; 100000000003 *** .704
; 100000000019 *** .719
; 100000000057 *** .718
; average runtime ~0.714
; runtime increased by factor of ~3.19

; sqrt(10) ~ 3.16
; that's PRETTY CLOSE to the empirically observed order of growth in runtime!
; "within error bars" of operating system's fluctuating load