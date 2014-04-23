; the very first version is very very simple
    ; guess->improve->iter loop in data diagram, with extra branch for good-enough?
        ; note that x feeds into both of these too though...

; is the point of doing this monolithically to show us how valuable it would be to have subroutines??
; (controller
;     test-guess
;         (test (op good-enough?) (reg guess) (reg x))
;         (branch (label sqrt-done))
;         (assign guess (op improve) (reg guess) (reg x))
;         (goto test-guess)
;     sqrt-done
; )

; version 2
; guess = (improve guess)
; (average guess (/ x guess))
; (/ (+ guess (/ x guess)) 2)
; although the asm reads RELATIVELY linearly, the data diagram is kinda twisted, if you reuse the division op.
    ; actually, the diagram CANNOT reuse the division operation - how would it know when to use which 
        ; alternatively, you could create special registers just for division, but that makes the asm messier
    ; sols and asm intuition say to reuse (op /) with different registers, without renaming as a separate op - (op /b), say
    
; (controller
;     test-guess
;         (test (op good-enough?) (reg guess) (reg x))
;         (branch (label sqrt-done))
;     
;         ; this part was expanded.
;         ; (assign guess (op improve) (reg guess) (reg x))
;         (assign temp (op /) (reg x) (reg guess))            ; reuse of temp makes diagram messier too.
;         (assign temp (op +) (reg temp) (reg guess))
;         (assign guess (op /) (reg temp) (const 2))
;         
;         (goto test-guess)
;     sqrt-done
; )


; version 3
; (good-enough? guess x)
; (< (abs (- (square guess) x)) 0.001))                     
; meh use square as a primitive? what about abs? heck, you could use sqrt...



(load "ch5-regsim.scm")
(define sqrt-machine (make-machine ; register-names ops controller-text

    '(guess x temp)
    (list 
        (list '/ /) 
        (list '+ +)
        (list '- -)
        ;(list 'square square) ; works, but let's not be cheap...
        ;(list 'abs abs)
        (list '* *) ; complete the 4-function shittenou!
        (list '< <)
    )
    '(
        (assign guess (const 1.0))

        test-guess
            
            ; this part was expanded.
            ;(test (op good-enough?) (reg guess) (reg x))
            
            ;;(assign temp (op square) (reg guess)) ; meh only saves a BIT of typing
            ;;(assign temp (op abs) (reg temp))     ; a bit TOO cheap
            ;;(test (op <) (reg temp) (const 0.001))    
                                          
            ; sols add an if-test, but i'd rather add an additional squaring and not have an additional branch...
            ; the FULL data flow diagram would get even MORE TWISTED, reusing temp 4 more times...
            ; but i'm not sure "duplicating" a REGISTER on a data diagram is wise
                ; primitive operations duplicate unambigiously, because they are assumed not to change
                ; but registers almost by DEFINITION will be changing.
            (assign temp (op *) (reg guess) (reg guess))        ; temp = (square guess)
            (assign temp (op -) (reg temp) (reg x))             ; temp = (- (square guess) x)
            (assign temp (op *) (reg temp) (reg temp))          ; temp = (square (- (square guess) x))
            (test (op <) (reg temp) (const 0.000001))           ; (< (square (- (square guess) x)) (square 0.001))
            
            (branch (label sqrt-done))
        
        improve ; label is unused, but clarifying
            (assign temp (op /) (reg x) (reg guess))            ; reuse of temp makes diagram messier too.
            (assign temp (op +) (reg temp) (reg guess))
            (assign guess (op /) (reg temp) (const 2))
            
            (goto (label test-guess))
        sqrt-done
    )
))

(set-register-contents! sqrt-machine 'x 2)
(start sqrt-machine)
(display (get-register-contents sqrt-machine 'guess)) (newline)
(display (sqrt 2.0)) (display " = exact")
; 1.4142157...
; 1.4142136... = exact