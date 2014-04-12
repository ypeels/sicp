; a variable is only considered unbound if it cannot be found in the current environment OR ANY ENCLOSING one.
    ; this function would only live up to its name if it actually MAKES a variable unbound.
    
; "rapid development" starting from an unrefactored version - because the changes are greater than in 4.12


    ; how do you remove an item from a list easily? delete! but only for intermediate entries!?
        ; the annoying part is having to also delete the corresponding entry from vals.
    
; sols: oh they want you to implement all the way back in eval. just do it like define/set!
    
(define (unbind? expr)
    (tagged-list? 'make-unbound! expr)) ; sols are wrong though about this though - they want make-unbound! to be a SPECIAL FORM
    
(define (unbinding-variable expr)
    (cadr expr))    ; no error checking - just like (assignment-variable).
    
(define (eval-unbinding expr env)
    (unbind-variable! (unbinding-variable expr) env))
    
(define (eval expr env)
  (cond
    ; ...
    ((unbind? expr)
        (eval-unbinding expr env))
    ; ...
  )
)
    

(define (unbind-variable! var env)

  ; if the NEXT list item is var, then SKIP it (screw garbage collection)
  ; the very first elem of all should have been checked in the main loop
  ; also, presupposes that var is never null
  (define (search-and-destroy! vars vals)
      
      (cond
          ((null? (cdr vars))
              'done)
          ((eq? var (cadr vars))
              (set-cdr! vars (cddr vars))
              (set-cdr! vals (cddr vals)))
          (else
              (search-and-destroy! (cdr vars) (cdr vals)))
      )
  )

  (define (env-loop env)
            
    (if (eq? env the-empty-environment)
        'done ;(error "Unbound variable" var)
        (let* ( (frame (first-frame env))
                (vars (frame-variables frame))
                (vals (frame-values frame))
                )  
                
            ; ugh still have to treat the first element asymmetrically
            (cond
                ((null? vars) ; is it POSSIBLE 
                    'skip-this-frame)
                ((eq? var (car vars))
                    (set-car! frame (cdr vars))
                    (set-cdr! frame (cdr vals)))
                (else
                    (search-and-destroy! vars vals))
            
          ; my design choice: unbind the variable in ALL enclosing environments.
          (env-loop (enclosing-environment env)))))
                
  (env-loop env))
  
; sols are pretty messed up, but i'm happy with my solution.