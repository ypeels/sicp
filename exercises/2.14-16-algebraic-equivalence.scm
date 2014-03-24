; what was the POINT of the time skip? it has nothing to do with the actual work in the exercise...
; yes, this is a common occurrence in software engineering, but just mentioning it in passing doesn't teach anybody that...

; "Examine the results of the computation in center-percent form"
(load "2.12-make-center.scm")   


; main text
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))
                                
; Exercise 2.14: "Demonstrate that Lem is right [that par1 and par2 give different results]"
(define (test-2.14 r1 p1 r2 p2 op1 name1 op2 name2)
    
    (let (  (interval1 (make-center-percent r1 p1))
            (interval2 (make-center-percent r2 p2)))
            
        (newline)
        (print-center-percent interval1) 
        (display " and ")
        (print-center-percent interval2)
        
        (newline) (display name1) (display " = ")
        (print-center-percent (op1 interval1 interval2))
        (newline) (display name2) (display " = ")
        (print-center-percent (op2 interval1 interval2))
        (newline)
    )
)

(define (test-par a b c d)
    (test-2.14 a b c d par1 "par1" par2 "par2"))

(test-par 1 1 1 1)
; par1 = .5 +/- 2.9992%
; par2 = .5 +/- 1%

(test-par 1 .1 1 .1)
(test-par 1 .01 1 .01) ; still don't match, even for miniscule errors. 
(test-par 1 0 2 0) ; reassuringly, 0% always stays 0%
        

; "Investigate the behavior of the system on a variety of arithmetic expressions."

; uh, how about 1 + (1/x) = (x+1) / x?
(define (recip1 x unused-argument)
    (let ((one (make-interval 1 1)))
        (add-interval one (div-interval one x))))
(define (recip2 x unused-argument)
    (let ((one (make-interval 1 1)))
        (div-interval (add-interval x one) x)))
(test-2.14 1 1 99 0 recip1 "recip1" recip2 "recip2") ; these are different too


; "Make some intervals A and B, and use them in computing the expressions A/A and A/B."
;(define (foo x y) (div-interval x x))

;(define quotient-self (lambda (xx, yy) (div-interval xx xx))) ; why does this not work??
;(define quotient-other (lambda (xx, zz) (div-interval xx zz)))
(define (quotient-self x y) (div-interval x x))
(define (quotient-other x y) (div-interval x y))

(define (test-div a b c d)
    (test-2.14
        a b c d
        quotient-self  "A/A";(lambda (xx, yy) (div-interval xx xx)) "A/A" why this not work????
        quotient-other "A/B";(lambda (xx, zz) (div-interval xx zz)) "A/B"
    )
)
        
(test-div 1 1 1 1)              ; A/A = 1 +/- 2%
(test-div 1 1 1 2)              ; A/B = 1 +/- 3%
(test-div 1 1 2 1)              ; A/B = .5 +/- 2%
(test-div 1 1 2 2)              ; A/B = .5 +/- 3%
(test-div 1 .000001 2 .00001)


; Exercise 2.15: "Eva Lu Ator... says that a formula to compute with intervals using Alyssa's system will 
; produce tighter error bounds if it can be written in such a form that no variable that represents an 
; uncertain number is repeated."

; Well, for |d| << 1:   1/(1-d) approx = 1+d (truncated geometric series expansion)
; Therefore, from Exercise 2.12, PERCENT ERRORS APPROXMIATELY ADD for division. (Ahh THAT'S why we did 2.12)
; This is especially problematic when you have something like A/A.
;   - if A represents a time-invariant physical quantity, then A/A = 1 +/- 0%.
;   - therefore, it is better to cancel the A's out on pencil/paper before evaluating by computer.

; Exercise 2.16: as for the general case, uh... i guess simplify symbolically first... that's what Mathematica is for...?
    ; http://en.wikipedia.org/wiki/Interval_arithmetic meh.
