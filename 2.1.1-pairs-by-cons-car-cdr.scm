; The "main" notes record new, non-obvious Scheme constructs as I encounter them in the main text.
; (They also record tidbits of random curiosity...)

; NONE of the following built-in primitives is obvious at ALL from its name!!
; This would be true of (lambda), too, if other languages did not borrow its usage
; Note: if you tried (define cons 1), the only warning you might have is SYNTAX HIGHLIGHTING in your editor
; Note 2: Looks like you can (define) away ANY built-in keyword - even (define) itself!!!
    ; (define define 1) ; don't do this


; create a pair
(define x (cons 1 2))

; READ elements of pair. the book hasn't shown how to write
(newline) (display (car x))   ; 1
(newline) (display (cdr x))   ; 2


; omfg wtf these are ASSEMBLY-LEVEL TERMS from the original Lisp implementation
; car = "Contents of Address part of Register"
; cdr = "Contents of Decrement part of Register" (pronounced "could-er")
; cons = construct (this one isn't so bad...)


; Note 3: pairs can be nested. Therefore, (cons) can create arbitrarily large data structures as binary trees.
(define y (cons 3 4))
(define z (cons x y))
(newline) (display (car (cdr z))) ; 3
(newline) (display (cdr (cdr z))) ; 4