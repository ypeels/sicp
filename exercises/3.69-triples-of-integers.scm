;(load "3.66-72-streams-of-pairs.scm")
(load "3.66-examining-integer-pair-stream.scm")
; can we just generalize the table decomposition on p. 339 to 3-d?
    ; corner
    ; TWO edges
    ; recurse to nested cube
    
; actually, it's a NESTED TETRAHEDRON
    
; or should i embed (pairs) inside this? 
    
; 

; starting from pairs routine. generates r <= s <= t
(define (triples r s t)
    (let ((st-pairs (pairs s t)))                           ; aha, the key is to call (pairs) again at each r level  
        (cons-stream 
            (cons (stream-car r) (stream-car st-pairs))     ; corner to prevent infinite recursion
            
            (interleave 
                (stream-map 
                    (lambda (x) (cons (stream-car r) x))    ; tack (car r) onto all st pairs. guaranteed to have r <= s <= t!
                    (stream-cdr st-pairs)
                )
                
                ; step ALL streams forward, so that the next call to (pairs) has no overlap with this r-level.
                (triples (stream-cdr r) (stream-cdr s) (stream-cdr t))
            )
        )
    )
)

(define (test-3.69)

    (let (  (num-pairs 20)    )
            
        (define (iter i triple-stream)
            (let ((current-triple (stream-ref triple-stream i)))            
                (newline)
                ;(display i) (display "\t")
                (display current-triple)
            )
            
            (if (< i num-pairs)
                (iter (+ i 1) triple-stream))
        )
        
        
        
        (define (pythagorean? a b c)
            (= (square c) (+ (square a) (square b))))
        
        (define pythagorean-triples
            (stream-filter
                (lambda (L) (apply pythagorean? L))
                (triples integers integers integers)
            )
        )
                
    
        
        ;(iter 0  (triples integers integers integers))
        (iter 0 pythagorean-triples)
        ; 3 4 5
        ; 6 8 10
        ; 5 12 13
        ; 9 12 15
        ; 8 15 17
        ; Aborting!: out of memory
        ; but my TRIPLES algorithm seems to work...
        
        
    )
)
            
;(test-3.69)            


