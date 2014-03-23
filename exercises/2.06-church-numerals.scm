; from problem statement
(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))
  
; "Hint: Use substitution to evaluate (add-1 zero)"
; (add-1 zero)
    ; = (lambda (f) (lambda (x) (f    ((zero f) x)   )))
        ; but (zero f) = ((lambda (f) (lambda (x) x)) f)
            ; = (lambda (x) x) ; independent of f!
    ; = (lambda (f) (lambda (x) (f    ((lambda (z) z) x)   )))
    ; = (lambda (f) (lambda (x) (f                 x       )))
(define one (lambda (f) (lambda (x) (f x))))

    
; similarly, (add-1 one)
    ; = (lambda (f) (lambda (x) (f    ((one f) x)   )))
        ; but (one f) = ((lambda (f) (lambda (x) (f x))) f)
            ; = (lambda (x) (f x)) ; and a pattern begins to emerge...
    ; = (lambda (f) (lambda (x) (f    ((lambda (z) (f z)) x)   )))
    ; = (lambda (f) (lambda (x) (f                 (f x)       )))
(define two (lambda (f) (lambda (x) (f (f x)))))






; "Give a direct definition of the addition procedure + (not in terms of repeated application of add-1)."
; uh.... ok, let's start from definitions...

; what we WANT to do is get more f's in there...
; hmm
(define (add-2 n)
    (lambda (f) (lambda (x) (f (f    ((n f) x)   )))))
    ; this tells me nothing...
    ; well, it draw my attention to the fact that ((n f) x) returns (f^n x), thus proving the general case
    
    
; curiosity: what does (one one) equal??
; (one one)
    ; = ((lambda (f) (lambda (x) (f x))) one)
    ; = (lambda (x)    (one x)   )
    ; = (lambda (x)    ((lambda (foo) (lambda (z) (foo z))) x)   )
    ; = (lambda (x)    ( lambda (z) (x z) ) ) 
    ; = one.
    ; have i stumbled on MULTIPLICATION? or is this a corner case?
    
; (zero one)
    ; = ((lambda (f) (lambda (x) x)) one)
    ; = (lambda (x) x) - this is NOT IN THE NUMBER SYSTEM
    
; (one zero)
    ; = ((lambda (f) (lambda (x) (f x))) zero)
    ; = (lambda (x) (zero x))
    ; = (lambda (x) (lambda (y) y))
    ; = zero. 

; (one n)
    ; = ((lambda (f) (lambda (x) (f x))) n)
    ; = (lambda (x) (n x))
    ; = (lambda (x)    ((lambda (f) (lambda (z) (f^n z))) x)   )
    ; = (lambda (x)                 (lambda (z) (x^n z))       )
    ; = (lambda (foo) (lambda (z) (foo^n z)))
    ; = n.
    
; ok, so what can we do with one, two, etc.?
    ; apply them (substitute for f)
    ; NEST them
    ; evaluate them to the end, convert to arithmetic, then reconstruct the lambda? but how do you get a counter in there??
    
; aha, how about ((m f) (n f))!?!? now we're getting twisted...
;(define (add m n)
;    (lambda (f) (lambda (x) (   (((m f) (n f)) x) ))))
; no, this gives a syntax error

; but me likes my original idea. how about ( (m f) ((n f) x) )?!
(define (add m n)
    (lambda (f) 
        (lambda (x)
            ((m f) ((n f) x)) ; ROAAARRRRRR!!!!!!! fiddling around pays off.
        )
    )
)

    
(define test-2.6 (lambda () ; hey, lambdas can have blank arguments!
    
    (define (inc x) (+ x 1))
    
    (define (print-church-numeral n)
        (newline)
        (display ((n inc) 0)))
        
    (print-church-numeral zero)             ; 0
    (print-church-numeral one)              ; 1
    (print-church-numeral two)              ; 2
    
    (define three (add one two))
    (print-church-numeral three)            ; 3    
    
    ; let's go fibonacci to make sure
    (define five (add three two))
    (print-church-numeral five)             ; 5
    
    (define eight (add five three))         
    (print-church-numeral eight)            ; 8
    
    (define thirteen (add eight five))
    (print-church-numeral thirteen)         ; 13
    
    
))
(test-2.6)
