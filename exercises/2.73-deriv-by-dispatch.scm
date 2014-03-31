(load "2.33-37-accumulate.scm")                 ; for my cheap sum-rule
(load "2.56-58-symbolic-differentiation.scm")   ; for (make-product and (make-sum
(load "2.56-power-rule.scm")
(load "2.57-n-sums.scm")                        ; for generalizing product rule to product of n factors (and "uncheap" sum rule)
(load "2.73-74-get-set-table.scm")

; from problem statement - with "exp" (which is a keyword) replaced by "expr"
(define (deriv expr var)
   (cond ((number? expr) 0)
         ((variable? expr) (if (same-variable? expr var) 1 0))
         (else ((get-2.73 'deriv (operator expr)) (operands expr)   ; changed from (get for part d.
                                            var))))
(define (operator expr) (car expr))
(define (operands expr) (cdr expr))
(define get-2.73 get)
(define put-2.73 put)


; "a.  Explain what was done above. Why can't we assimilate the predicates number? and variable? into the data-directed dispatch?"
; Rules were moved into table lookup, indexed by operator.
; When exp is a number or a variable (symbol), (operator exp) will fail, because they are not lists.



; b.  Write the procedures for derivatives of sums and products, and the auxiliary code required to install them 
;       in the table used by the program above.

; proceeding analogously to (install-rectangular-package from Section 2.4.3
(define (install-derivs-2.73b)

    (define (sum-rule-v1-cheap expr-list var)
        (accumulate                                     ; gettin' fancy/lazy. handles (+ x x x x) like a champ!
            make-sum
            0                                           ; simplifier in (make-sum will get it.
            (map (lambda (e) (deriv e var)) expr-list)
        )
    )
    
    (define (product-rule-v1 expr-list var)
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
    
    
    
    (define (addend term-list)
        (car term-list))
    (define (multiplier factor-list)
        (car factor-list))    
    
    (define (multiplicand factor-list)
        (let ((p (cons '* factor-list)))                ; hmmmmm a wee bit low-level...    
            (if (product? p)
                (multiplicand-2.57 p)
                (error "called on non-product: MULTIPLICAND" p)
            )
        )
    )
    (define (augend term-list)                          ; analogously to (multiplicand, and too many changes to be worth abstracting?
        (let ((s (cons '+ term-list)))
            (if (sum? s)
                (augend-2.57 s)
                (error "called on non-sum: AUGEND" s)
            )
        )
    )
                
        
    (define (product-rule-v2 expr-list var)
        (let ((f1 (multiplier expr-list)) (f2 (multiplicand expr-list)))
            ;(if (<= (length remaining-factors) 1)
            (make-sum 
                (make-product f1 (deriv f2 var))
                (make-product f2 (deriv f1 var))
            )
        )
    )
    (define (sum-rule-v2 expr-list var)
        (let ((t1 (addend expr-list)) (t2 (augend expr-list)))
            (make-sum (deriv t1 var) (deriv t2 var))
        )
    )
    
    
    ; i think they want to treat PRODUCTS and SUMS as different TYPES!? yes - see part d.
    (put-2.73 'deriv '+ sum-rule-v1-cheap)
    ;(put-2.73 'deriv '+ sum-rule-v2) ; works, but i likes my cheapness
    (put-2.73 'deriv '* product-rule-v2)
)
        

        
; c.  Choose any additional differentiation rule that you like, such as the one for exponents (exercise 2.56), 
;       and install it in this data-directed system.
(define (install-derivs-2.73c)

    (define (base expr-list)
        (car expr-list))
    (define (exponent expr-list)
        (cadr expr-list))

    (define (power-rule expr-list var)
        (cond
            ((not (= 2 (length expr-list)))
                (error "Require (** y n) - POWER-RULE" expr-list (length expr-list)))
            ((not (number? (exponent expr-list)))
                (error "Require numerical exponent - POWER-RULE" expr-list))
            
            ; the rest is from Exercise 2.56
            (else
                (let ((u (base expr-list)) (n (exponent expr-list)))    
                    (make-product
                        n
                        (make-product 
                            (** u (- n 1))
                            (deriv u var)
                        )
                    )
                )
            )
        )
    )
        
        
    (put-2.73 'deriv '** power-rule)
)

 
        
        
        
(define (test-2.73)

    (define (test expr)
        (display "\n\nf(x) = ") (display expr)
        (display "\nf'(x) = ") (display (deriv expr 'x))
    )

    (install-derivs-2.73b)
    (test '(+ x x x x))     ; 4
    (test '(* x 2))         ; 2    
    (test '(* 2 6))         ; 0
    (test '(* x x))         ; (+ x x)
    (test '(+ x (* x x)))   ; (+ 1 (+ x x))
    (test '(* 3 x x))       ; (* 3 (+ x x))
    (test '(* x x x))       ; (+ (* x (+ x x)) (* x x))
    
    (install-derivs-2.73c)
    (test '(** x 2))        ; (* 2 x)
    (test '(** x 5))        ; (* 5 (** x 4))
    (test '(** (+ x 1) 2))  ; (* 2 (+ x 1))
    
    
)

; (test-2.73)



    
; d.  Suppose, however, we indexed the procedures in the opposite way, so that the dispatch line in deriv looked like
    ; ((get (operator exp) 'deriv) (operands exp) var)
; What corresponding changes to the derivative system are required? 

; previously 
    ; ((get 'deriv (operator exp)) (operands exp) var)


; well, all the (put statements would have to flip too
    ; what is happening here? 
    ; 2.4.3: (put <op> <type> <procedure>)
    ; now 'deriv is a "data TYPE" and <op> ('*, '+) is the "operation"
    ; you're JUST flipping rows and cols of your table, so it should work just fine if you flip the order in (put...
    ; who knows what the correct row/column mapping is, if there is one...

; here; i'll prove it to you.    
; (define (get-2.73 a b) (get b a)) (define (put-2.73 a b c) (put b a c)) (test-2.73)