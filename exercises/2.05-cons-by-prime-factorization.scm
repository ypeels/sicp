; the hardest part of this exercise was READING it and figuring out what it means...

; extractability depends on the fundamental theorem of arithmetic
(define (cons a b) 
    (if (not (and (integer? a) (integer? b)))
        (error "Arguments not integers" a b)
        (* (expt 2 a) (expt 3 b))        
    )
)


; this function returns the number of times "base" can divide into "x"
; it is intended for use with a base that is prime, for "partial prime factorization"
(define (primelog x base) 
    (if (= 0 (remainder x base))
        (+ 1 (primelog (/ x base) base))
        0))
        
(define (car pair) (primelog pair 2))
(define (cdr pair) (primelog pair 3))
    
        


; test code, again copied from section 2.1.3
(define x (cons 1 2))
(define y (cons x x))
(newline) (display (car x))
(newline) (display (cdr x))
(newline) (display (car (car y)))