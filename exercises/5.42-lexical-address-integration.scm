(define (install-compile-var-set-5.42)

    (set! compile-variable-compiler compile-variable)
    (set! compile-variable compile-variable-5.42)
    
    (set! compile-assignment-compiler compile-assignment)
    (set! compile-assignment compile-assignment-5.42)
)
(define compile-variable-compiler '*unassigned*)
(define compile-assignment-compiler '*unassigned*)
(define f '*unassigned*) ; mwahahaha now this is accessible interactively!
(define g '*unassigned*)



; pre-condition: expr is a variable (symbol)
(define (compile-variable-5.42 expr target linkage . other-args)
    (let* ( (ctenv (compile-time-environment other-args))
            (addr (find-variable expr ctenv))
            )
    
        ; "In cases where...the variable is not in the compile-time environment...
        ; you should have the code generators use the evaluator operations, as before"
        
        (if (eq? addr (invalid-lexical-address))
            
            ; Mark I - punt to superclass, not worrying about get-global-environment
            ;(compile-variable-compiler expr target linkage)
            
            ; Mark II - search the global environment directly, which is the only place left it could be
            (end-with-linkage linkage
                (make-instruction-sequence '() (list target)
                    `(
                        (assign ,target (op get-global-environment)) ; meh, it's getting trashed anyway
                        (assign ,target (op lookup-variable-value) (const ,expr) (reg ,target))
                    )
                )
            )                                    
            
            ; lexical address found! use it to find value in runtime env
            (end-with-linkage linkage
                (make-instruction-sequence '(env) (list target)
                    `(
                        ;(assign ,target (const ,addr)) ; target is getting trashed anyway
                        
                        ; return (lexical-address-lookup address env)
                        (assign 
                            ,target 
                            (op lexical-address-lookup) 
                            (const ,addr) ; figured this out during compile-assignment ;(reg ,target)
                            (reg env)
                        )
                    )
                )
            )
        )
    )
)



; ugh, to test this, need some test code 
(define (compile-assignment-5.42 expr target linkage . other-args)
    (let* ( (ctenv (compile-time-environment other-args))
            (var (assignment-variable expr)) ; watch out! expr is NOT a variable now!!
            (addr (find-variable var ctenv))
            )
            
        ; basic logic from compile-variable-5.42
        ; too short to be worth consolidating
        (if (eq? addr (invalid-lexical-address))
        
            ; Mark I - punt to superclass, not worrying about get-global-environment
            (apply compile-assignment-compiler
                (append (list expr target linkage) other-args))
            
            ; compile-variable-5.42 + compile-assignment
            (end-with-linkage linkage
                (preserving '(env)
                    
                    ; get-value-code. meh, no real need for a (let)! true in original too...
                    (apply compile (append 
                        (list (assignment-value expr) 'val 'next)
                        other-args))
                    
                    
                    (make-instruction-sequence
                        '(env val)      ; needs
                        (list target)   ; modifies
                        `(
                            ; (lexical-address-set! address env val)
                            (perform 
                                (op lexical-address-set!)
                                (const ,addr) ; why hello there, this worked! ;addr (reg ,target) won't work. what if ,target is val!?
                                (reg env)
                                (reg val)
                            )
                            
                            (assign ,target (const ok))
                        )
                    )
                )
            )
        )            
    )
)




(define (test-5.42)
    (load "ch5-compiler.scm") ; i wonder why this isn't included in load-eceval-compiler.scm
    (load "load-eceval-compiler.scm")
    (load "5.39-lexical-address-lookup.scm")
    (load "5.40-compile-time-env-in-lambda-body.scm") (install-compile-lambda-body-5.40)
    (load "5.41-find-variable-in-ct-env.scm")
    (install-compile-var-set-5.42) ; bwahahaha now the scoping of this makes SENSE!

    ; I would really like to avoid duplicating this code...    
    (define test-variable
        ; from 5.5.6 (i don't have (let) implemented, so let's stick with desugared)
        '((lambda (x y)
           (lambda (a b c d e)
             ((lambda (y z) (* x y z))
              (* a b x)
              (+ c d x)))) 
          3 
          4)
    )
    
    ; ohhhh http://stackoverflow.com/questions/16873043/how-do-i-evaluate-a-symbol-returned-from-a-function-in-scheme
    (set! f (eval test-variable user-initial-environment))
    (display "\n(f 1 2 3 4 5) = ") (display (f 1 2 3 4 5))
    
    (define test-assignment
        ';(let ((count 0))
        (   
            (lambda (count)
                (lambda ()
                    (set! count (+ count 1))
                    count
                )
            )
            0
        )
    )
    (set! g (eval test-assignment user-initial-environment))
    (newline) (display (g))
    (newline) (display (g))
    (newline) (display (g))
    (newline) (display (g))
    
    
    (set! eceval (make-machine 
        eceval-compiler-register-list
        (append eceval-operations (list 
            (list 'lexical-address-lookup lexical-address-lookup)
            (list 'lexical-address-set! lexical-address-set!)
        ))
        eceval-compiler-main-controller-text
    ))
    
    (define start '*unassigned*)
    (set! start (lambda ? 'ignored)) ; for testing code before feeding it to compiler/eceval
    (set! start compile-and-go)
    
    (start
        `(begin 
            (define f ,test-variable)
            (f 1 2 3 4 5)
            ; should be 180
            
            (define g ,test-assignment)
            (g)
            (g)
            (g)
    

        )
        ;'val
        ;'next ; ohhh these shouldn't be here
        (list '()) ; default compile-time environment
    )
)
(test-5.42)
