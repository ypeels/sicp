; this is less refactoring than it is feature bloat...

; minor modification to accumulate-iterative
(define (accumulate-filter combiner null-value term a next b condition?)
    (define (iter x result)
        (if (> x b)
            result
            (iter 
                (next x)
                
                (combiner 
                    result 
                    (if (condition? x)              ; this is the new addition.
                        (term x)
                        null-value)))))
                    
                
    (iter a null-value))

    
(define (product-iter-1.33 term a next b) (accumulate-filter * 1 term a next b always)) ; my testing
    
; some stupid tiny functions
(define (always x) #t)
(define (never x) #f)
(define (inc x) (+ x 1))


    
; WAY more time is spent writing test code and making sure "support code" is present, 
; than on design and actually writing "real" code    ...
(define (test-1.33)

    ;;;;;;;;;;;;;;;;;;;;;;;
    ; Exercise 1.33a. i mean, you COULD move this all to file-scope... but that'd drag in 1.22-24 also...
    (load "1.22-24-display-and-newline.scm")        ; for (prime?)    
    (define (squared-primes a b)
        (accumulate-filter 
            +                                       ; accumulation is summation
            0                                       ; null value
            square                                  ; each term is squared
            a
            inc                                     ; check ALL numbers (meh brute force)
            b
            prime?                                  ; deterministic primality test from exercise 1.22ish
            ))
            
    (define a 2)
    (define b 12)
    (display "\nSum of squares of primes between ") (display a) (display " and ") (display b) (newline)
    (display (squared-primes a b))
    (display "\nAnswer should be ") (display (+ (square 2) (square 3) (square 5) (square 7) (square 11)))
    
    ;;;;;;;;;;;;;;;;;;;;;;;
    ; Exercise 1.33b
    
    ; from ch1.scm
    (define (greatest-common-divisor a b)   ; (gcd) is a scheme built-in?? come ON, mr. scheme
      (if (= b 0)
          a
          (greatest-common-divisor b (remainder a b))))
        
    (define (id x) x)
    (define (rel-prime? a b) (= 1 (greatest-common-divisor a b)))
    (define (relatively-prime-product n)
        (define (rel-prime-with-n? x) (rel-prime? x n))
        (accumulate-filter                          ; this is almost like using an API now...        
            *                                       ; accumulation is productation
            1                                       ; null value
            id                                      ; each term is unprocessed
            2
            inc                                     ; check ALL numbers
            (- n 1)                                 ; do not lump n into its own product
            rel-prime-with-n?                       ; NOT just (rel-prime?), which takes TWO arguments
            ))
            
    (define (test-rel-prime-product n)
        (display "\nProduct of all i < ")
        (display n)
        (display " that are relatively prime with the upper limit: ")
        (display (relatively-prime-product n)))

    (newline)
    (test-rel-prime-product 6)                      ; should be 5
    (test-rel-prime-product 7)                      ; should be 720 = 6!
    (test-rel-prime-product 8)                      ; should be 3 * 5 * 7 = 105    
    
)

(define (next-divisor d) (inc d)) (test-1.33)    ; ugh, let's not break the upstream code

; my other test code    
;(load "1.31-product.scm") (define (product-iter term a next b) (product-iter-1.33 term a next b)) (test-1.31)


