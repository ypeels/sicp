(load "3.66-67-streams-of-pairs.scm")

; instead of ordered pairs with i <= j.

; how about cheating and just swapping the order of (pairs) and filtering out diagonal members?
; this would WORK, but it's not at the desired granularity - they want a modification of the pairs procedure...
;(load "3.66-examining-integer-pair-stream.scm")

; ohhhh just do the column too before recursing
(define (all-pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    
    ; new
    (interleave
        (stream-map (lambda (x) (list x (stream-car t)))    ; just symmetrize. that should be all! don't forget to swap list order.
                    (stream-cdr s))                        
    
        ; old
        (stream-map (lambda (x) (list (stream-car s) x))
                    (stream-cdr t))
    )
    (all-pairs (stream-cdr s) (stream-cdr t)))))        



(define (test-3.67)


    ; i DON'T think you can just (interleave integers integers)
        ; well, first, that just gives you a STREAM, not a stream of PAIRS
        ; second, that intuition is right: 1 1 2 2 3 3 4 4 5 5 6 6... pretty useless.
        
    (let (  ;(int-pairs (interleave integers integers))
            (int-pairs (all-pairs integers integers))
            (num-pairs 20)
            )
            
        (define (iter i)
            
            (let ((current-pair (stream-ref int-pairs i)))            
                (newline)
                ;(display i) (display "\t")
                (display current-pair)
            )
            
            (if (< i num-pairs)
                (iter (+ i 1)))
        )
        (iter 0)
    )
)
;(test-3.67)