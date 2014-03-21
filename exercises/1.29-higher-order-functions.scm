;(load "ch1.scm")  ; meh, i'm tired of typing  --- no actually, this gives "maximum recursion depth reached" EVEN FOR (integral cube 0 1 0.01)

; from chi1.scm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (cube x) (* x x x))
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2)) add-dx b)
     dx))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; analogous to (integral)
(define (simpson-integral f a b dx)

    (define (term x)                        ; f from "global" f - constrained by (sum) API
        (+  (* 1 (f x)) 
            (* 4 (f (+ x dx)))              ; dx from "global" dx
            (* 1 (f (+ x (* 2 dx))))))
            
    (define (add-2-dx x) (+ x (* 2.0 dx)))        

    (* (sum term a add-2-dx b)
       (/ dx 3.0)))
       

(define (test-1.29)

    ; simpson's rule
    (newline)
    (display (simpson-integral cube 0 1 0.01))  ; 0.2500000000
    (newline)
    (display (simpson-integral cube 0 1 0.001)) ; 0.2500000000
        
        
    ; midpoint rule
    (newline)
    (display (integral cube 0 1 0.01))          ; 0.2499875
    (newline)
    (display (integral cube 0 1 0.001))         ; 0.249999875
)

; (test-1.29) ; uncomment to run test suite