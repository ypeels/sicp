(define (eval expr env)
  (cond
    ; ...
    ((unless? expr) (eval (unless->if expr) env))
    ; ...
  )
)

(define (unless? expr)
    (tagged-list? 'unless expr))
    
(define (unless->if expr)
    (make-if
        (if-predicate expr)
        (if-alternative expr)       ; just swap the order of the clauses - no need for (not)
        (if-consequent expr)
    )
)




; but i'm NOT really sure about alyssa's argument...
    ; even if (unless) were available as a procedure, the arguments to (map) et al. would NOT be evaluated lazily
    ; also, can't you USE special forms in higher-order procedures?
    ; on the other hand, can't you just wrap (unless) or (if) with a lambda to use it as a procedure??
        ; oh no, that's right, you can't pass (if) directly as a FUNCTION PARAMETER
(define (foo special-form)
    (display "\nfoo")
)
(foo if)  ; syntactic keyword may not be used as an expression
  
        ; higher-order procedure NEED NOT mean (map) - just any procedure that takes a procedure as an argument
            ; Section 1.3: "Procedures that manipulate procedures are called higher-order procedures."
        
        
        
        
