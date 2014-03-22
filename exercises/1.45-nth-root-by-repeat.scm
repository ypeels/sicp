; from ch1.scm ;;;;;;;;;;;;;;
(define (average x y)
  (/ (+ x y) 2))
  
(define (average-damp f)
  (lambda (x) (average x (f x))))

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(load "1.16-fast-expt-iter.scm")    ; wait, (expt) is also a built-in!?  "Assume that any arithmetic operations you need are available as primitives. " 
;(load "1.35-36-fixed-point.scm")    ; for (fixed-point) that outputs results at every iteration
(load "1.43-repeat-by-lambda.scm")  ; for (repeated)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (nth-root-testing x n dampings)
    (fixed-point
        ((repeated average-damp dampings)
            (lambda (y) (/ x (expt y (- n 1)))))     ; y = x/y^(n-1) means y^n = x
        1.                                           ; initial guess
    )
)

(define (nth-root x n)
    (define (log2 x) (/ (log x) (log 2)))           ; my proposed # dampings is log2(n).
    (nth-root-testing x n (floor (log2 n))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    
; shared by both pre- and post-testing, so can't move it inside any function...
(define (test-1.45-output x n root)
    (newline)
    (display n)
    (display "n-th root of ")
    (display x)
    (display ": ")
    (display root)
    (display "\ncheck by raising back to nth power - should be ")
    (display x)
    (display ": ")
    (display (expt root n))
)
    

(define (test-1.45-experimental x n dampings)    
    (define root (nth-root-testing x n dampings))   ; should probably use a (let)...
    (test-1.45-output x n root)    
)
    



;(define (f n dampings) (test-1.45-experimental 2. n  dampings)) ; for experimentation


; empirical results 
; D is defined such that the program hangs for dampings < D, oscillating forever)
; - another observation: for dampings > D, it takes more iterations to converge (smaller steps?)
;   n   D
; -----------   
;   2   1
;   3   1
;   4   2
;   5   2
;   6   2! hmm is it powers-of-2 based?
;   7   2 - slower convergence than dampings = 3, though?
;   8   3
;   15  3
;   16  4

    
    


(define (test-1.45) 
    
    (define (test x n) (test-1.45-output x n (nth-root x n)))

    (test 2 2)
    (test 3 3)
    (test 4 4)
    (test 9 9)
    (test 100 15) 
    (test 100 17)
    (test 99 99)
)
    
; (test-1.45)
    
    
