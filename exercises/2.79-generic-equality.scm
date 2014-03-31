(load "2.77-80-generic-arithmetic.scm")
(load "2.78-obsoleting-scheme-number.scm") ; ugh, thanks to my horrible implementation, (load must be at global scope...
; just like the definitions of (add, (sub, ...
(define (equ? x y) (apply-generic 'equ? x y))

(define (install-equality-2.79)

    (error "ERROR ugh, add directly to the library file 2.77-80, cuz this is just too cheap...")

    (put 'equ? '(scheme-number scheme-number) =)    ; hey lookee, a 1996, maybe 1980's smiley. intentional?
    

    
    (define (equal-rationals? r1 r2)                ; r1 and r2 have been stripped of type information when they enter...
        ;(newline) (display r1) (newline) (display r2)
    
        ; now, i COULD modify (install-rational-package, but that's for wusses
        ; however, this must exploit the fact that (gcd 0 n) = n        
        
        ;(equal? (make-rational 0 123) (sub r1 r2))
        
        ; no, (apply doesn't work, so you'd need to examine the low-level structure of r1. meh.
        ;(let ((q1 (apply make-rational r1)) (q2 (apply make-rational r2)))
        ;    (equal? (make-rational 0 123) (sub q1 q2)))
        
        
        
        ; ugh, but in the end, if i'm not gonna exploit lower-level routines, i have to use equal?, but why not use that directly??
        (equal? r1 r2)
        
        
        
    )
    (put 'equ? '(rational rational) equal-rationals?)
    
    'done
)





(define (test-2.79)
    ;(display "Exercise 2.79: installing EXTERNAL equality package...") (install-equality-2.79)
    
    
    
    ; meh, added directly to the "2.77-80" library file to be more in the spirit of the exercise.
    
    (define (test x y)
        (display "\n\nx = ") (display x) (display ". equals itself? ") (display (equ? x x))
        (display "\ny = ") (display y) (display ". x = y? ") (display (equ? x y))
    )
    
    
    (test (make-scheme-number 2) (make-scheme-number 2))
    (test (make-scheme-number 2) (make-scheme-number 3))
    ; ehhh can't go here?? (load "2.78-obsoleting-scheme-number.scm")
    (test 1 1)
    (test 1 2)
    (test (make-rational 3 4) (make-rational 3 4))
    (test (make-rational 3 4) (make-rational 3 5))
    
    (test (make-complex-from-real-imag 3 4)  (make-complex-from-real-imag 3 4))
    (test (make-complex-from-real-imag 3 4)  (make-complex-from-real-imag 3 4.01))
    (test (make-complex-from-mag-ang 2 1.57) (make-complex-from-mag-ang 2 1.57))
    (test (make-complex-from-mag-ang 2 1.57) (make-complex-from-mag-ang 2 1.58))
    
)

; (test-2.79)

; the moral? adding an operation to a type will PROBABLY require modifying the original "type installer"
    ; that is, if you need to access its "private" functions, which are not in scope externally...