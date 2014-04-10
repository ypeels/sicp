(load "3.66-72-streams-of-pairs.scm")

(define (pairs-3.68 s t)
  (newline) (display (stream-car s)) (display "\t") (display (stream-car t))
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               t)
   (pairs-3.68 (stream-cdr s) (stream-cdr t))))
   
(define (test-3.68)



        ; plug and chug first, and ask questions later
    (let (  (int-pairs (pairs-3.68 integers integers))
            (num-pairs 20)
            )
            
        (define (iter i)
            
            (let ((current-pair (stream-ref int-pairs i)))            
                (newline)
                (display current-pair)
            )
            
            (if (< i num-pairs)
                (iter (+ i 1)))
        )
        ;(iter 0)
        
        (display (stream-ref int-pairs 0))
    )
)
; (test-3.68) ; Aborting!: maximum recursion depth exceeded.
; this occurs even if you try to get the very first member of (pairs integers integers)!
; this occurs even before you try to evaluate (stream-ref) - it occurs on the CALL to (pairs integers integers)

; there doesn't seem to be anything wrong with the (stream-map) call per SE...?? what am i missing?
    ; well clearly there is something bad about the RECURSION
    
; ok, empirically, the construction of the stream is trying to evaluate ALL the diagonal elements.
    ;  (pairs 1... 1...) = (1 1) and (pairs 2... 2...)
        ; (pairs 2... 2...) = 
        
    ; i guess the problem is that the first element in louis' (pairs) is a call to (interleave)??
        ; but that should only be ...?
        
    ; oh the call to interleave IS NOT DEFERRED!!
        ; it's an ordinary function, so of course it's gonna evaluate both its arguments.
        ; infinite recursion!