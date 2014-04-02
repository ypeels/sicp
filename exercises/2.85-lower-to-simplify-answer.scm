(load "2.83-raise-to-more-general-type.scm")
(load "2.84-coercion-by-slow-raising.scm")

(load "2.77-complex-number-selectors.scm") ; omfg like louis reasoner, i needed this hack too!! the shame... 


(install-complex-reps-2.77) ; but why does it have to be called AFTER 2.83 and 2.84 load?? ugh the stupid intricacies of the scheme runtime...
(install-builtin-number-package 'integer)  ; and why do these have to be called again!?!? well, at least it's deterministic...
(install-builtin-number-package 'real)
(install-raise-2.83)
(install-default-values-2.84) (define get-coercion get-coercion-2.84)


                                                                       
; by analogy with raise. this might better be named "lower", but whatever, just more stupidity. chapter 4 better be worth it...
    ; well they are saving "drop" for the simplification procedure that gets called if (raise (project == identity
(define (project x)
    (if (can-project? x)
        (apply-generic 'project x)
        x
    )
)
(define (can-project? x)
    ;(display "\n\t\tcan-project? ") (display x)
    (and
        (pair? x)
        (get 'project (list (type-tag x)))
    )
)

; finally using the result of Exercise 2.79
(define (equ? x y)
    (apply-generic 'equ? x y))
    
; by analogy with install-raise-2.83
(define (install-project-2.85)
    
    
    ; remember, these functions take UNTAGGED values as arguments
    (define (project-comp-to-real z-untagged)
        (let ((z (attach-tag 'complex z-untagged)))                 ; the alternative would be to alter the complex package...
            (make-real (real-part z))
        )
    )
    (put 'project '(complex) project-comp-to-real)
    
    (define (project-real-to-rat x)                                 ; remember, these are UNTAGGED
        (let ((denom 10000))
            (make-rational
                (round (* x denom))
                denom
            )
        )
    )
    (put 'project '(real) project-real-to-rat)
    
    (define (project-rat-to-int r-untagged)                         ; remember, these are UNTAGGED
        (let ((r (attach-tag 'rational r-untagged)))
            (make-integer (round (/ (numer-rational r) (denom-rational r))))))
    (put 'project '(rational) project-rat-to-int)
    
    "Installed (project, the poorly-named inverse of (raise, for Exercise 2.85."
)


; uh... required by (drop... 
(display (install-project-2.85)) 


(define (drop x) x)


; this function lowers objects in the tower if it doesn't destroy information.
; e.g., (raise (project 2.34 + 0i)) will be lowered to 2.34
(define (drop x)
    ;(display "\n\tdrop(): ") (display x)
    (cond
        ((not (can-project? x))
            ;(display "no go\n")
            x)
        ((equ? x (raise (project x)))
            ;(display "hello dolly\n")
            (drop (project x)))
        (else 
        
            ;(display "project-raise destroys information: ")
            ;(display x) 
            ;(display (raise (project x)))
            ;(newline)
        
        
        x)                        ; COULD combine with the bottom rung code, but this shows intent a LITTLE more cleanly...?
    )
)



; and here my compulsive numbering pays off...ALMOST
(define (apply-generic-2.85 op . args)
    ;(display "\n\tapply-generic-2.85 args = ") (display op) (display args)
    
    (let ((upstream-result (apply apply-generic-2.81-86 (cons op args))))  ; STUPID STUPID PARENTHESES    
        (cond   ; WHY do cond and cons only differ by ONE LETTER!? come ON, this is horribly like assembly...
        
            ; need to watch out because this function is also used to get RAW numer-rational
            ((not (can-project? upstream-result))
                upstream-result)
                
            ; also do NOT try to (drop if the operation was raise/project. infinite recursion lies there...
            ((or (eq? op 'raise) (eq? op 'project))
                upstream-result)
                
            (else
                (drop upstream-result))
        )
    )
)



;;;;;;;; the syntax is soooooo annoying
; yes, in PRINCIPLE you can make things as modular as you want
; but if the language gets in your friggin WAY, then who's gonna have the patience~!?!?!



(define (test-2.85)

    (define (pre-test x)
        (display "\n\nx = ") (display x)
        (display "\nraise = ") (display (raise x))
        (display "\nproject = ")(display (project x))
    )
    
    
    (define (test x y)
        (newline)
        (display x) (display " + ") (display y)
        (let ((ans (add x y)))
            (display " = ")
            (display ans)
        )
    )
    
    (let (  (i (make-integer 1))
            (q (make-rational 1 2))
            (r (make-real 1.5))
            (z (make-complex-from-real-imag 3 0))
            (z2 (make-complex-from-real-imag 3 1))
        )

        (pre-test i)
        (pre-test q)
        (pre-test r)
        (pre-test z)
        (newline)
            
        (test i i)
        (test i q)
        (test q q)
        (test r r)
        (test r q)
        (test z z)
        (test z r)
        (test r z)
        (test r z2)
        (test z2 q)
    )
    "goodbye world"
)
       

       

(define apply-generic apply-generic-2.85) (test-2.85)



; (display "\nhello world\n")
; ; (define apply-generic apply-generic-2.77-80)
; (define z (make-complex-from-real-imag 1 2))
; (display (real-part z))

