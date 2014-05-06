

; i think the easiest way to do this is to 
    ; check the compile-time environment, and 
    ; only open-code if the operator isn't found 
        ; [open-coding refers only to the OPERATOR of a given expression]
        
(define (open-code-expr? expr other-args)
    (let ((result
            (and 
                (pair? expr)
                (memq (operator expr) '(+ - * =))
                
                (if (has-compile-time-environment? other-args) 
                    (eq? 
                        (invalid-lexical-address) ; they really should have specified #f instead of 'not-found
                        (find-variable (operator expr) (compile-time-environment other-args)))
                    true
                )                    
            )
         ))
        
        ;;(newline)
        ;(if (pair? expr)
        ;    (display (operator expr))
        ;)
        ;(display result)
        ;(if (and (pair? expr) (has-compile-time-environment? other-args))
        ;    (begin
        ;        (newline)
        ;        (display (operator expr))
        ;        (display (find-variable (operator expr) (compile-time-environment other-args)))
        ;        (display (compile-time-environment other-args))
        ;    )
        ;        
        ;)
        
        
        result
    )
          
            
)
        
        
(define (compile-5.44 expr target linkage . other-args)
    
    ; hey, that's IT??
    (if (open-code-expr? expr other-args)
        (apply compile-5.38 (append (list expr target linkage) other-args))
        (apply compile-compiler (append (list expr target linkage) other-args))
    )
)

    

(define compile-compiler '*unassigned)
(define (install-compile-5.44)
    (if (eq? compile-compiler '*unassigned)
        (begin
            (set! compile-compiler compile)
            (set! compile compile-5.44)
            
            (set! eceval (make-machine 
                (append eceval-compiler-register-list '(arg1 arg2))
                (append eceval-operations (list (list '+ +) (list '- -) (list '* *) (list '= =)))
                eceval-compiler-main-controller-text
            ))
        )
    )
)

(define (test-5.44)
    (display "hello")

    (load "ch5-compiler.scm") ; i wonder why this isn't included in load-eceval-compiler.scm
    (load "load-eceval-compiler.scm")
    (load "5.38-open-coded-primitives.scm")
    ;(load "5.39-lexical-address-lookup.scm") ; not using lexical addresses
    (load "5.40-compile-time-env-in-lambda-body.scm") (install-compile-lambda-body-5.40) ; needed to extend the compile-time env
    (load "5.41-find-variable-in-ct-env.scm") ; needed to traverse the compile-time env
    ;(load "5.42-lexical-address-integration.scm") (install-compile-var-set-5.42) ; not using lexical addresses

    
    (define test-operator-overload
        '(begin
        
            ; for regression testing - to make sure open-coding didn't break
            (define (factorial n)
             (if (= n 1)
                 1
                 (* (factorial (- n 1)) n)))
            
            (define (f x) x)
            (define (plus-one x) (+ x 1))
            (define (f + x) (+ x))
            (f plus-one 9) ; should output 10...
            ;'hello
            ;(+ 1 2)
            ;(f 1)
        )
    )
    
    (display "\nFrom underlying scheme: ") 
    (display (eval test-operator-overload user-initial-environment))
    
        
    
    ;(install-compile-5.38); original open-coding will result in EC-Eval: 9
    (install-compile-5.44) ; outputs 10 correctly
    
    (compile-and-go
        test-operator-overload
        (empty-compile-time-environment) ; don't forget! this argument is OPTIONAL
    )
    

)
(test-5.44)


