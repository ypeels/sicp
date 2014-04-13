; a.  Change lookup-variable-value (section 4.1.3) to signal an error if the value it finds is the symbol *unassigned*.
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
            
             ;(car vals))
             ; NEW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             (if (eq? (car vals) '*unassigned* )        ; '*unassigned* is now a forbidden/keyword value!
                (error "Unassigned variable - LOOKUP-VARIABLE-VALUE" var)
                (car vals)))
             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

             
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

  
; c.  Install scan-out-defines in the interpreter, either in make-procedure or in procedure-body (see section 4.1.3). 
;       Which place is better? Why? 
;   (make-procedure) is better, so you aren't re-scanning EVERY time you apply
    ; unless you are sure your procedure is only going to be evaluated 0-1 times??
    ; (make-procedure) is only called in the (lambda?) clause of (eval), but that's ok!
        ; function definitions via (define) are turned into lambdas in (definition-value exp)
(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-defines body) env)) ;body env))        
        

  
; here's the least trivial part
; b.  Write a procedure scan-out-defines that takes a procedure body and returns an equivalent one that 
;       has no internal definitions, by making the transformation described above.

; do i need to worry about whether the procedure body starts with a (begin)??
; or does something exotic? how about not now...?
(define (test-4.16)
    (begin
        (define x 1)
        (newline)
        (display x)
    )
)
;(test-4.16) ; 1



    ; currently not working for internal PROCEDURE definitions
    ; is THAT why sols use (definition?) ? but can (let) HANDLE functions? meh
(define (scan-out-defines body)

    ; cf. (definition-value)
    (define (internal-definition? expr)
        (and (tagged-list? 'define) (symbol? (cadr expr)))) ; sols use (definition?) directly. hmmmm...
        
    (define (all-internal-definitions expr-list)
        (cond
            ((null? expr-list)
                '())
            ((internal-definition? (car expr-list))
                (cons 
                    (car expr-list);(list (cadr expr-list) (caddr expr-list)) ; (<var> <value>) from (define <var> <value>)
                    (all-internal-definitions (cdr expr-list))))
            (else
                (all-internal-definitions (cdr expr-list)))
        )
    )
    
    ; non-DRYly reuses the loop structure and inefficiently makes a second pass
    ; but whatever - i'm not even testing this...
    (define (rest-of-body expr-list)
        (cond
            ((null? expr-list)
                '())
            ((internal-definition? (car expr-list))
                (rest-of-body (cdr expr-list)))
            (else
                (cons (car expr-list) (rest-of-body (cdr expr-list))))
        )    
    )
    
    (define (wrap-with-let definitions rest-of-body)
        
        ; breaking the seal on "map" - since they used it in the book on p. 382, despite Footnote 5
        (let (  (vars (map definition-value definitions))
                (vals (map definition-variable definitions)))
            (let (  (unassigned-bindings (map (lambda (var) (list var '*unassigned*)) vars))
                    (assignments (map (lambda (var val) (list 'set! var val)) vars vals)))
        
                (make-let
                    unassigned-bindings
                    (append
                        assignments
                        rest-of-body    ; or is rest-of-body not a list? meh who knows... i get the picture.
                    )
                )
                    
                
            )
        )
    )
        
        
    
    
    
    ; construct and return the nested let
    (let (  (internal-definitions (all-internal-definitions body))
            (rest-of-body (rest-of-body body))
            
        (if (null? internal-definitions)
            body
            (wrap-with-let internal-definitions rest-of-body)
        )
    )
            
            
    
)
    
    
    
    
        