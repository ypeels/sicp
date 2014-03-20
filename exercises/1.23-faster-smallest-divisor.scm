(load "1.22-24-display-and-newline.scm")

;(define (next-divisor-original d) (+ d 1)) ; default from Exercise 1.22


(define (next-divisor-book-1_23 d)
    (if (= d 2)
        3
        (+ d 2)))

; an even faster version that requires d and the number being examined to always be odd
(define (next-divisor-fast d) (+ d 2)) ; requires (smallest-divisor) to seed with 3 instead of 2...
(define (smallest-divisor-fast n) (find-divisor n 3))

; aha, this is the correct comparison
(define (next-divisor-fair d)
    (if (= d 2)
        3
        (+ d 1)))

; ---------------------------------------------------------
; THE KEY DEFINITION - vary for testing
;(define (next-divisor d) (next-divisor-original d))
;(define (next-divisor d) (next-divisor-book-1_23 d))
;(define (next-divisor d) (next-divisor-fast d))     (define (smallest-divisor n) (smallest-divisor-fast n))
(define (next-divisor d) (next-divisor-fair d))
; ---------------------------------------------------------



        
; runtimes are original (no extra function call) -> (next-divisor-original) -> (next-divisor-book-1_23) -> (next-divisor-fair)
        
(search-for-primes 100000000 100000040)
; 100000007 *** .016 -> .015 -> .015 -> .016
; 100000037 *** .016 -> .016 -> .016 -> .031
; 100000039 *** .031 -> .031 -> .016 -> .031


(search-for-primes 1000000000 1000000030)
; 1000000007 *** .063 -> .078 -> .046 -> .094
; 1000000009 *** .078 -> .078 -> .047 -> .094
; 1000000021 *** .063 -> .078 -> .031 -> .094
; speedup ~2 for (next-divisor-original) -> (next-divisor-book-1_23)

(search-for-primes 10000000000 10000000065)
; 10000000019 *** .234 -> .250 -> .141 -> .297
; 10000000033 *** .219 -> .25  -> .141 -> .297
; 10000000061 *** .219 -> .235 -> .141 -> .281
; speedup ~1.8 for (next-divisor-original) -> (next-divisor-book-1_23)

(search-for-primes 100000000000 100000000060)
; 100000000003 *** .704 -> .796 -> .454 -> .922
; 100000000019 *** .719 -> .782 -> .438 -> .968
; 100000000057 *** .718 -> .797 -> .453 -> .953
; speedup ~1.8 for (next-divisor-original) -> (next-divisor-book-1_23)


(search-for-primes 1000000000000 1000000000065)
; 1000000000039 *** 2.329 -> 2.486 -> 1.406 -> 3.045
; 1000000000061 *** 2.343 -> 2.483 -> 1.406 -> 3.031
; 1000000000063 *** 2.344 -> 2.484 -> 1.437 -> 3.046
; speedup ~1.8 for (next-divisor-original) -> (next-divisor-book-1_23)

; for REALLY LARGE numbers, the speedup is only 1.8ish...
; there must be some significant additional work being done in addition to the repeated calls to (find-divisor)?
; also, note that there is some overhead incurred by abstracting (next-divisor) into its own procedure and running those comparisons
    ; uh, i GUESS it's the extra comparison and (if) in the new (next-divisor)?
    ; INDEED, [(smallest-divisor-fast) + (next-divisor-fast)] gives ~2. speedup rel. to [(smallest-divisor) + (next-divisor-original)]
    ; equivalently, compare with (define (next-divisor-fair d) (= d 2) 3 (+ d 1)) - then it's closer to 2.1?

