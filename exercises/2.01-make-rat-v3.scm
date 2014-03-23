; from ch2.scm ;;;;;;;;;;;;;;;;;;;;;;;
(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define (make-rat-v1 n d) (cons n d))    ; v1
(define make-rat make-rat-v1)         

(define (numer x) (car x))

(define (denom x) (cdr x))

(define (print-rat x)
  (display (numer x))
  (display "/")
  (display (denom x))
  (newline))                            ; changed to post-endl 
  
(define (make-rat-v2 n d)                ; v2
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))
(define make-rat make-rat-v2) ; meh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (make-rat-v3 n d)

    (define (neg x) (- 0 x))

    (if (= 0 d)
        (error "Rational number with zero denominator" d)
    
        (let ((g (gcd (abs n) (abs d))))   ; (n2 (/ n g)) (d2 (/ d g)) does NOT work!! only checks ENCLOSING scope
        
            ; (let (n2 (/ n g)) (d2 (/ d g)) ; screw that...too nested to be easily legible......
            (define n2 (/ n g))
            (define d2 (/ d g))
        
            (cond
                
                ; same sign - eat the extra (abs) calls for + +
                ((>= (* n2 d2) 0)                                       ; fuck you, prefix operator order (had order switched because i'm used to NORMAL languages by now)
                    (cons (abs n2) (abs d2)))
                    
                ; must have different signs. eat extra abs calls to keep code SHORT...
                (else
                    (cons (neg (abs n2)) (abs d2)))
            )
        )
    )
)
(define make-rat make-rat-v3) ; needed to update (add-rat) etc. comment out to see older versions in action.

(define (test-2.1)

    (define (test n d)
        (newline)
        (let ((x (make-rat n d)))
            (display "x   = ") (print-rat x)
            (display "x+x = ") (print-rat (add-rat x x))            
            (display "x-x = ") (print-rat (sub-rat x x))
            (display "x*x = ") (print-rat (mul-rat x x))
            (display "x/x = ") (print-rat (div-rat x x))
              
            x
        )
    )
    
    (test 1 2)
    (test -4 8)
    (test 4 -9)
    (test -9 -6)
    ;(test 0 0)  ; should cause error
    ;(test 0 1) ; should cause error in division test
)

; (test-2.1)
        
        