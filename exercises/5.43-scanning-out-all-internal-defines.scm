; cf. exercise 4.16 (which i never tested?)

; meteorgan just uses (scan-out-defines) inside (compile-lambda-body), and i see no reason to do anything more complicated

; remember, a procedure MUST be a lambda
    ; even with (define), (definition-value) makes sure (make-lambda) gets called.

; HOWEVER, he didn't bother implementing (let)
    ; one way around this would be to redo Exercise 4.6 for the compiler
        ; but i do NOT feel like writing new compiler code...not if i can avoid it...
    ; a lazier way is to wrap (scan-out-defines) from 4.16 with a new procedure "(desugar-let)"
        ; 1. internal defines converted into a wrapping (let)
        ; 2. the wrapping (let) converted further into (lambda) application
        ; 3. compile the fully-wrapped result.
        
        ; wait a goshdarn minute, does this NOT WORK, in concept??
            ; (define (f) (define x 1) x)
            ; (define (f) (let ((x 'unassigned)) (set! x 1) x))
            ; (define (f) ( (lambda (x) (set! x 1) x) 'unassigned ))
                ; uh, this SHOULD be ok...
                ; x = 'unassigned
                ; then x gets set to 1
                ; then return current value of x
        
        
        
(define (compile-lambda-body-5.43 expr proc-entry . other-args)
    ;(apply compile-lambda-body-5.40 (append
    (apply compile-lambda-body-compiler (append
        (list 
            (make-lambda
                (lambda-parameters expr)
                (desugar-let                            ; from below
                    (scan-out-defines                   ; from 4.16
                        (lambda-body expr)
                    )
                )
            )
            proc-entry
        )
        other-args
    ))
)

(define compile-lambda-body-compiler '*unassigned)

(define (install-compile-lambda-body-5.43)
    
    (set! compile-lambda-body-compiler compile-lambda-body) ; no, let's do a sequential override...
    
    
    (set! compile-lambda-body compile-lambda-body-5.43) ; punts explicitly to 5.40, so no further aliasing needed
    
    
)

(define (desugar-let expr)
    (if (let? expr)
        (let* ( (bindings (let-bindings expr))
                (formals (let-parameters bindings)) ; kinda ironic using let to desugar let
                (vals (let-values bindings))
                (body (let-body expr))
                (result
                    ; hey, is this IT?
                    (append
                        (list (make-lambda formals body))
                        vals
                    )
                ))
              
          (display "\nlet body = ") (display body)
          (display "\ndesguar-let result: ") (display result)
          result

        )
        
        ; oh right, i'm calling this unconditionally in compile-lambda-body
        expr
    )
)
            
            









        
        
        
; example code
; i dunno about all the stupid subtleties from 4.1.6...
; but at the very least, this code should not break!




; my horrible solution to 4.16 can't handle this?
;(define test-body-5.43 '(begin (define number 42) number)) ; haha, this runs into problems as an internal define

(define start-5.43 '*unassigned*)


(define (test-5.43)

    (load "ch5-compiler.scm")
    (load "load-eceval-compiler.scm")
    (load "5.33-38-compiling-to-file.scm") ; for testing
    ;(load "5.39-lexical-address-lookup.scm")
    ;(load "5.41-find-variable-in-ct-env.scm")
    ;(load "5.42-lexical-address-integration.scm") (install-compile-var-set-5.42)

    (load "4.06-let.scm") ;(set! let-body (lambda (expr) (cddr expr))) ; changed from caddr - to parallel (lambda-body). didn't feel like changing old code and checking that stuff didn't break.
    (load "4.16-scanning-out-all-internal-defines.scm") ; hey, i never tested this...
    ;(load "5.40-compile-time-env-in-lambda-body.scm") (install-compile-lambda-body-5.40)
    (install-compile-lambda-body-5.43)
    
    
    
    (define test-internal-define
        `(define (f)
            (define number 42) number
        )
    )
    
    
    
    ; syntax from 5.42
    (eval test-internal-define user-initial-environment)
    (display "\nFrom underlying scheme: ")(display (f))
    
    
    ; some unit testing...cuz my answer to 4.16 was never tested
    ;(newline) (display (scan-out-defines '((define number 42) number)))
    ;(newline) (display (desugar-let (scan-out-defines '((define number 42) number))))
    
    
    
    
    
    ; from 5.42
    (set! eceval (make-machine 
        eceval-compiler-register-list
        (append eceval-operations (list 
            ;(list 'lexical-address-lookup lexical-address-lookup)
            ;(list 'lexical-address-set! lexical-address-set!)
        ))
        eceval-compiler-main-controller-text
    ))
    
    
    (set! start-5.43 (lambda (expr) (compile-to-file expr 'val 'return "test.txt")))
    ;(set! start-5.43 (lambda (expr) (compile-and-go expr (list '()))))
    
    
    ;(start
    (start-5.43
        ;`(begin
            test-internal-define
        ;    (f)
        ;)
    )
    
    
)
(test-5.43)