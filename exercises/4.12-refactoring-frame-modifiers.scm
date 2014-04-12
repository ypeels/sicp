(define (lookup-variable-value var env)
    (lookup-or-set!-variable-value var env (lambda (vals) (car vals))))
  
(define (set-variable-value! var val env)
    (lookup-or-set!-variable-value var env (lambda (vals) (set-car! vals val))))
    
; lookup and set only differ in ONE LINE
(define (lookup-or-set!-variable-value var env op)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- LOOKUP-OR-SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)
                (lambda () (env-loop (enclosing-environment env)))
                (lambda (vals) (op vals))))))
  (env-loop env))
  
  
  
  ; define-variable is a SINGLE ITERATION of env-loop.
    ; COULD cheaply modify (lookup-or-set!) with a flag
    ; but it's probably CLEANER and far more comprehensible to pull scan out completely
(define (define-variable! var val env)
  (let ((frame (first-frame env)))  
    (scan (frame-variables frame)
          (frame-values frame)
          (lambda () (add-binding-to-frame! var val frame))
          (lambda (vals) (set-car! vals val)))))
        
; refactored out. pretty abstract looking, but hopefully clear enough...        
(define (scan vars vals null-action found-action)
  (cond ((null? vars)
         (null-action))                             ; need to vary this starting with define!
        ((eq? var (car vars))
         (found-action vals))                       ; needed to vary this between lookup and set!
        (else (scan (cdr vars) (cdr vals)))))
                  
; sols rename everything, and i don't feel like reading them