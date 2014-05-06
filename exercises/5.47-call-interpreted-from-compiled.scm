; uh, easy enough by analogy...?
    ; but how does ('procedure ...) data ever get passed in?
    ; from (lookup-variable-value)? i GUESS...
(define (compile-procedure-call-5.47 target linkage)              
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
        (compound-branch (make-label 'compound-branch))                 ; <---- new
        (after-call (make-label 'after-call)))
    (let ((compiled-linkage                                  
           (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
       (make-instruction-sequence '(proc) '()                
        `((test (op primitive-procedure?) (reg proc))        
          (branch (label ,primitive-branch));))     
          
          (test (op compound-procedure?) (reg proc))                    ; 2 new lines
          (branch (label ,compound-branch))))
          
       (parallel-instruction-sequences    
        (parallel-instruction-sequences                                 ; <---- new (can't take more than 2 arguments)
            (append-instruction-sequences
             compiled-branch                                     
             (compile-proc-appl target compiled-linkage))        
            
            (append-instruction-sequences                               ; 3 new lines
             compound-branch
             (compound-proc-appl target compiled-linkage)))
        
        
        (append-instruction-sequences
         primitive-branch                                    
         (end-with-linkage linkage
          (make-instruction-sequence '(proc argl)
                                     (list target)
           `((assign ,target                                 
                     (op apply-primitive-procedure)
                     (reg proc)
                     (reg argl)))))))                        
       after-call))))



; uh, just mimicking (compile-proc-appl)...
    ; note that linkage comes from the COMPILER
(define (compound-proc-appl target linkage)

    ; yep, this looks correct from my testing!
    (define questionable-command '(save continue));'(assign val (reg val)));
    ;(define questionable-command '(assign val (reg val))); "nop" results in "empty stack"!

    (cond
        ((and (eq? target 'val) (not (eq? linkage 'return)))
            
            ; i THINK eceval naturally puts the "return value" into val...
            (make-instruction-sequence '(proc) all-regs `(
                (assign continue (label ,linkage))
                
                ; removed!
                ; compound-apply in eceval will parse proc for params, env, and body
                ; no need to do anything here. good thing, too, cuz i have no IDEA how to find the entry point
                ;(assign val (op compiled-procedure-entry) (reg proc))                
                
                ; NEW! i THINK this is needed by compound-apply - emulates the beginning of ev-application
                ; without this, ev-sequence is gonna kill this, one way or another!
                ,questionable-command     
                
                ; changed! goto compound-apply in eceval, as per the problem statement.
                (goto (reg compapp))
            ))
        )
        ((and (not (eq? target 'val)) (eq? linkage 'return))
            (let ((proc-return (make-label 'proc-return)))
                (make-instruction-sequence '(proc) all-regs `(
                    (assign continue (label ,proc-return))
                    ,questionable-command ; oops, without evaluating this, it just becomes a LABEL
                    (goto (reg compapp))
                    ,proc-return
                    (assign ,target (reg val))
                    (goto label ,linkage)
                ))
            )
        )
        ((and (eq? target 'val) (eq? linkage 'return))
            (make-instruction-sequence '(proc) all-regs `(
                
                ; return linkage means continue already contains the return point.
                ; still adding this new save, as in case 1.
                ,questionable-command
                
                (goto (reg compapp))
            ))
        )
        ((and (not (eq? target 'val)) (eq? linkage 'return))
            (error "return linkage, target not val -- COMPILE" target) ; to enforce tail-recursiveness
        )
        (else (error "impossible case"))
    )
)



(define (install-compile-procedure-call-5.47)
    (set! compile-procedure-call compile-procedure-call-5.47)
)



(define (test-5.47)
    (load "ch5-compiler.scm")
    (load "load-eceval-compiler.scm")
    (install-compile-procedure-call-5.47)
    (compile-and-go
        '(begin
            (define (f x) (g x))
        )        
    )
    ; EC-Eval: (f 0) 
    ; Unbound variable g
    
    ; EC-Eval: (begin (define (g x) (+ x 1)) (f 0))
    ; 1
)
(test-5.47)