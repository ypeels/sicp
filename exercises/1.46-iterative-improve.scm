; Write a procedure iterative-improve that takes two procedures as arguments: 
    ; a method for telling whether a guess is good enough   (good-enough? x)
    ; and a method for improving a guess                    (improve x). NOTE FUNCTION SIGNATURES!    
(define (iterative-improve good-enough? improve)

    ; Iterative-improve should return as its value a procedure 
        ; that takes a guess as argument 
        ; and keeps improving the guess until it is good enough
        
    ;(define (find x good-enough? improve)           ; do i necessarily need to bind (good-enough?) and (improve)?
    ;    (if (good-enough? x)
    ;        x
    ;        (find (improve x) good-enough? improve)))
    ;    
    ;(lambda (guess) (find guess good-enough? improve))  
    
    ; actually this works too - (good-enough?) and (improve) are "bound" from function arguments!
    (define (find x)                               ; but i think i DO need to (define) (find). if it were a bare lambda, how would it call itself??
        (if (good-enough? x)                       ; hmm, i think there ARE ways to do this, but they're neither more concise nor easier to understand...
            x                                      ; http://stackoverflow.com/questions/7719004/in-scheme-how-do-you-use-lambda-to-create-a-recursive-function
            (find (improve x))))        
    (lambda (guess) (find guess))
    

)
    
    
(define (mysqrt x)

    ; from ch1.scm - but remove x from the parameter lists to bind x - otherwise incompatible with "iterative-improve API"
    (define (good-enough? guess)                    ; originally (good-enough? guess x)
        (< (abs (- (square guess) x)) 0.001))
    
    (define (improve guess)                         ; originally (improve guess x)
        (average guess (/ x guess)))

    (define (average x y)
        (/ (+ x y) 2.))                             ; sneak in a decimal point to get floating point results
        
    ((iterative-improve good-enough? improve) x)
        
)


(define (fixed-point f initial-guess)
    
    (let ((tolerance 0.00001))
        (define (close-enough? v1 v2)
            (< (abs (- v1 v2)) tolerance))
            
        (define (good-enough? guess)
            (close-enough? guess (f guess)))
            
        ((iterative-improve good-enough? f) initial-guess)
    )
)


(define (test-1.46)

    (define (test-sqrt sqrt-function x)
        (display "\n\nsqrt ")
        (display x)
        (newline) (display (sqrt-function x))
        (newline) (display (sqrt x)) (display " exact")
    )
    
    (define (test-sqrt-suite sqrt-function)
        (test-sqrt sqrt-function 2)
        (test-sqrt sqrt-function 4)
        (test-sqrt sqrt-function 99)
        ;(test-sqrt sqrt-function 100)
    )    
    
    (test-sqrt-suite mysqrt)
    
    
    ; all ideas from section 1.3.3
    (display "\n\nand now to test the fixed-point stuff\n")
    (display (fixed-point cos 1.0))                               ; should be .7390822985224023
    (newline)
    (display (fixed-point (lambda (y) (+ (sin y) (cos y))) 1.0))  ; should be 1.2587315962971173
    
    (define (average x y) (/ (+ x y) 2.))
    (define (sqrt-by-fixed-point x) (fixed-point (lambda (y) (average y (/ x y))) 1.))
    (test-sqrt-suite sqrt-by-fixed-point)
    
)


(test-1.46)
