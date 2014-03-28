(load "2.56-58-symbolic-differentiation.scm")


(define (sum? x)
    (infix-2-term x '+))
(define (product? x)
    (infix-2-term x '*))
(define (infix-2-term x symbol)
    (and 
        (pair? x)
        ; (length x ; meh they didn't error-check either in the text
        (eq? symbol (cadr x))
    )
)


    
(define (addend s)
    (first-term s))
(define (multiplier p)
    (first-term p))
(define (first-term x)
    (car x))
    
; these actually don't change from prefix form
;(define (augend s)
;    (second-term s))
;(define (multiplicand p)
;    (second-term p))
;(define (second-term x)
;    (caddr x))



(define (make-sum a1 a2)                                ; modified from p. 149 version
    (cond 
        ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))                          ; the only difference
    )
)



(define (make-product m1 m2)                            ; modified from p. 150 version
    (cond
        ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))     
        (else (list m1 '* m2))                          ; the only difference
    )
)



(define (test-2.58a)
    
    (newline) (display (deriv '(x * x) 'x))
    (newline) (display (deriv '(x + (3 * (x + (y + 2)))) 'x))       ; 4
    (newline) (display (deriv '((x * y) * (x + 3)) 'x))             ; (x * y) + (y * (x + 3))
    
)

;(test-2.58a)
           
           