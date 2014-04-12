(define (lookup-variable-value var env)
    (lookup-or-set!-variable-value var env (lambda (vals) (car vals))))
  
(define (set-variable-value! var val env)
    (lookup-or-set!-variable-value var env (lambda (vals) (set-car! vals val))))
  
; lookup and set only differ in ONE LINE
(define (lookup-or-set!-variable-value var env op)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (op vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))
  
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))