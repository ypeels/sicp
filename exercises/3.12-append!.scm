(define x (list 'a 'b))
(define y (list 'c 'd))
(define z (append x y))
(display z)             ; (a b c d)

(newline)
(display (cdr x))
; <response>            ; (b)

(define w (append! x y))                    ; <---- built-in in MIT Scheme
(newline)
(display w)             ; (a b c d)

(newline)
(display (cdr x))       ; (b c d)

(newline)
(display (last-pair w)) ; (d)               ; <----- built-in in MIT Scheme


; Draw box-and-pointer diagrams to explain your answer. 
    ; i'm not even gonna dignify that with a response. except this. and this. and this...
    
    ; note how the idea of modifying the scheme interpreter in chapter 4 is "recursively self-referential"