; a.
; "A procedure application is any compound expression that is not one of the above expression types."
; also, (define (application? exp) (pair? exp))
; thus, as written, (eval exp env) will mistakenly think EVERYTHING is a procedure, except
    ; self-evaluating
    ; variable
    ; quote
    
; the underlying problem is the "negative" definition of a procedure application.
    ; (pair?) is a necessary condition for (tagged-list?)
    ; this (application?) HAS to go last!
    
    
; b. Just change the definition of (application?) and co. to match other similar "keywords"
(define (application? exp (tagged-list? exp 'call)) ; (pair? exp))
(define (operator exp) (cadr exp))                  ; (car exp))
(define (operands exp) (cddr exp))                  ; (cdr exp))

; now louis can reorder the (application?) clause to his liking.
; this comes at the price of preceding EVERY procedure call with "call". for all end users. for all programs.
