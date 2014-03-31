(load "2.33-37-accumulate.scm")                 ; for my cheap sum-rule
(load "2.56-58-symbolic-differentiation.scm")   ; for (make-product and (make-sum
(load "2.73-74-get-set-table.scm")

; from problem statement - with "exp" (which is a keyword) replaced by "expr"
(define (deriv expr var)
   (cond ((number? expr) 0)
         ((variable? expr) (if (same-variable? expr var) 1 0))
         (else ((get 'deriv (operator expr)) (operands expr)
                                            var))))
(define (operator expr) (car expr))
(define (operands expr) (cdr expr))


; "a.  Explain what was done above. Why can't we assimilate the predicates number? and variable? into the data-directed dispatch?"
; Rules were moved into table lookup, indexed by operator.
; When exp is a number or a variable (symbol), (operator exp) will fail, because they are not lists.



; b.  Write the procedures for derivatives of sums and products, and the auxiliary code required to install them 
;       in the table used by the program above.

; proceeding analogously to (install-rectangular-package from Section 2.4.3
(define (install-derivs-2.73b)

    (define (sum-rule expr-list var)
        (accumulate                                     ; gettin' fancy/lazy. handles (+ x x x x) like a champ!
            make-sum
            0                                           ; simplifier in (make-sum will get it.
            (map (lambda (e) (deriv e var)) expr-list)
        )
    )
        
        
    (define (product-rule expr-list var)
        (if (not (= 2 (length expr-list)))
            (error "Only handling products of 2 for now - use Exercise 2.57 to generalize? PRODUCT-RULE" expr-list)
            (let ((f1 (car expr-list)) (f2 (cadr expr-list)))
                (make-sum 
                    (make-product f1 (deriv f2 var))
                    (make-product f2 (deriv f1 var))
                )
            )
        )
    )
            
    
    
    
    
    ; i think they want to treat PRODUCTS and SUMS as different TYPES!? yes - see part d.
    ;(put 'deriv '*
    (put 'deriv '+ sum-rule)
    (put 'deriv '* product-rule)
)
        

        
(define (test-2.73)
    (install-derivs-2.73b)
    
    (define (test expr)
        (display "\n\nf(x) = ") (display expr)
        (display "\nf'(x) = ") (display (deriv expr 'x))
    )
    
    (test '(+ x x x x))     ; 4
    (test '(* x 2))         ; 2    
    (test '(* 2 6))         ; 0
    (test '(* x x))         ; (+ x x)
    (test '(+ x (* x x)))   ; (+ 1 (+ x x))
    
)

(test-2.73)
    