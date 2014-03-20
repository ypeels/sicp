(load "1.22-24-display-and-newline.scm")
(load "1.24-25-fast-prime-by-fermat.scm")
        
        
        
; override the test in (start-prime-test)
(define number-of-fermat-tests 2000)  ; increased until i got long enough runtimes for meaningful comparison
(define (prime? n) (fast-prime? n number-of-fermat-tests))



; expect runtime to increase linearly with log n.
; the nice thing about this is that i can increase the cost by simply tweaking number-of-fermat-tests
(search-for-primes 100000000 100000040)
; 100000007 *** .172
; 100000037 *** .172
; 100000039 *** .172

(search-for-primes 1000000000 1000000030)
; 1000000007 *** .203
; 1000000009 *** .187
; 1000000021 *** .203
; average runtime ~.198
; runtime increased by factor of ~1.15, AMOUNT of .026

(search-for-primes 10000000000 10000000065)
; 10000000019 *** .235
; 10000000033 *** .219
; 10000000061 *** .234
; average runtime ~.229
; runtime increased by factor of ~1.16, AMOUNT of .031

(search-for-primes 100000000000 100000000060)
; 100000000003 *** .267
; 100000000019 *** .265
; 100000000057 *** .265
; average runtime ~.266
; runtime increased by factor of ~1.16, AMOUNT of .037

; runtime is increasing ROUGHLY LINEARLY as n increases by orders of magnitude. meh, good enough