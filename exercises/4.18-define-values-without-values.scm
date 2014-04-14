; since i don't really fully understand the discussion, let's approach this from an EMPIRICAL angle.

(load "3.53-62-stream-operations.scm")
(load "3.78-80-integral.scm")
(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)
(newline) (display (stream-ref (solve (lambda (y) y) 1 0.001) 1000))  ; should be 2.716924, from above Exercise 3.77
(display " - original answer from Section 3.5.4")
; 2.716924


; for the new methods from this section
(define (integral-undelayed integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                                int)))
  int)


; try Method 1
(define (solve1 f y0 dt)

    (let (  (y '*unassigned*)
            (dy '*unassigned*)
            )
        (set! y (integral (delay dy) y0 dt))
        ;(set! y (integral-undelayed dy y0 dt))
        (set! dy (stream-map f y))
        y
    )
)
(newline) (display (stream-ref (solve1 (lambda (y) y) 1 0.001) 1000))
(display " - Method 1 from Section 4.1.6")
; 2.716924

; try Method 2
(define (solve2 f y0 dt)
    (let (  (y '*unassigned*)
            (dy '*unassigned*)
            )
        (let (  (y2 (integral (delay dy) y0 dt))
                (dy2 (stream-map f y))
                )
            (set! y y2 ) ; scheme doesn't like y' - it thinks there's a symbol ') ?
            (set! dy dy2)
        )
        y
    )
    
)
(newline) (display "asdf") (display (stream-ref (solve2 (lambda (y) y) 1 0.001) 1000))
(display " - Method 2 from Section 4.1.6")
; Unknown arguments to STREAM-MAP

; ok, so the mysterious sentence in the text means that Method 2 enforces a restriction - it is stricter.
    ; The restriction seems to be that 
    
    ; ok, i think i finally see - because of the nature of a (let) [not a (let*)], all variables come into existence SIMULTANEOUSLY.
    ; in (solve1), y and dy are simultaneously set to '*unassigned
        ; then y is set to (integral...)
        ; THEN dy is set to (stream-map f y)
            ; because these steps were sequential, dy knows the value of y.
            ; the (delay dy), which isn't evaluated until a (force) comes along, is a red herring!
            
    ; in (solve2), y2 and dy2 are evaluated SIMULTANEOUSLY
        ; y2's definition is fine
        ; but dy2 must evaluate (stream-map f y), BEFORE y has been set to y2
            ; y is still '*unassigned*! hence the balk.
            ; further evidence: (stream-map (lambda (z) z) 'asdf) gives the SAME ERROR.
    
    ; the restriction is clearer as: "the defined variables' values can be evaluated without using any of the [OTHER] variables' values."
        ; well, it's understood that if it's not another variable, it's a recursive definition, which is not usable...right?? meh
    

    ; does Footnote 25 mean that the (solve) is flouting the IEEE standard?
    
    
    
; wrote this stuff out, but just got confused. no wonder they gave a concrete example to work with...
;   "Unlike [Method 1]... [Method 2] enforces the restriction that the defined variables' values can be 
;   evaluated without **using** any of the variables' values." [emphasis added]
;   
;   ok, in Method 2, <e1> and <e2> may depend on u and v SYMBOLICALLY, since they live in the enclosing scope???
;   
;   In Method 1, however, if <e1> or <e2> depends on the value of u or v, you'll be using '*unassigned* in set! - right??
    ; empirically, it's the opposite???
    
    ; one clarification: they stated the restriction MORE CLEARLY a couple paragraphs back, but didn't explicitly call it a restriction:
        ; "evaluation of the value expressions for the defined variables
            ; doesn't actually use any of the defined variables"

;   Method 1
;   --------
;   (lambda <vars>
;     (let ((u '*unassigned*)
;           (v '*unassigned*))
;       (set! u <e1>)
;       (set! v <e2>)
;       <e3>))
;   
;   desugared
;   (lambda <vars>
;       (
;           (lambda (u v)
;               (set! u <e1>)
;               (set! v <e2>)
;               <e3>
;           )
;           '*unassigned*
;           '*unassigned*
;       )    
;   )
;       
;   
;   
;       
;   Method 2
;   --------
;   (lambda <vars>
;     (let ((u '*unassigned*)
;           (v '*unassigned*))
;       (let ((a <e1>)
;             (b <e2>))
;         (set! u a)
;         (set! v b))
;       <e3>))
;       
;   desugared
;   (lambda <vars>
;       (
;           (lambda (u v)            
;               (
;                   (lambda (a b)
;                       (set! u a)
;                       (set! v b)
;                   )
;                   <e1>
;                   <e2>
;               )            
;               <e3>
;           )
;           '*unassigned*
;           '*unassigned*
;       )
;   )
;       
;   








    
