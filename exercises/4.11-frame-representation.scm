; a list of pairs seems more intuitive to me anyway...
    ; ah, but it requires more work upfront in (make-frame)
    ; taking that into consideration, the book's pair of lists is probably more "natural"
    
(define (make-frame variables vals)
    (if (null? variables)
        '()
        (cons 
            (cons (car variables) (car (vals)))
            (make-frame (cdr variables) (cdr vals))
        )
    )
)
            

; meh just rewrite lookup
;(define (frame-variables frame) (car frame))
;(define (frame-values frame) (cdr frame))

; could also use append! but text's pair of lists also uses set + cons instead of append!
(define (add-binding-to-frame! var val frame)
    (set! frame (cons (cons var val) frame)))
    
; environment data structure hasn't changed - still just a list of frames, most recent at front
;(define (extend-environment vars vals base-env)
;...
  
; for simplicity, just rewriting lookup-variable-value; see next exercise for refactoring of original.
(define (lookup-variable-value var env)
  (define (env-loop env)
  
    ; needs full rewrite because frame data structure has changed from pair of lists to list of pairs.
    (define (scan frame)
        (cond
            ((null? frame)
                (env-loop (enclosing-environment env)))
            ((eq? var (caar frame))
                (cdar frame))
            (else
                (scan (cdr frame)))
        )
    )
            
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        ;(let ((frame (first-frame env)))
          ;(scan (frame-variables frame)
          ;      (frame-values frame)))))
          
          ; (scan)'s signature changed
          (scan (first-frame env))))
                
  (env-loop env))
  
; sols
    ; one uses map + cons/car/cdr and is like 5 lines long.
    ; one uses assoc and doesn't even have an auxiliary function scan...