(load "ch4-query.scm")  

; Alyssa P. Hacker proposes to use a simpler version of stream-flatmap in negate, lisp-value, and find-assertions...
; the procedure that is mapped over the frame stream in these cases always produces either the empty stream or a 
; singleton stream, so no interleaving is needed when combining these streams.


;(define (stream-flatmap proc s)                          
;  (flatten-stream (stream-map proc s)))                  
;
;(define (flatten-stream stream)                          
;  (if (stream-null? stream)
;      the-empty-stream
;      (interleave-delayed                                
;       (stream-car stream)                               
;       (delay (flatten-stream (stream-cdr stream))))))


; from problem statement
(define (simple-stream-flatmap-4.74 proc s)      ; ok, at least the signature didn't change
  (simple-flatten (stream-map proc s)))     ; also, the argument of flatten didn't change
  
; 2 possible inputs
; - stream = the-empty-stream
; - stream = ((frame))

; 2 corresponding outputs
; - the-empty-stream, which is what you get when you (stream-map <foo> the-empty-stream)
; - (frame)

; a. Fill in the missing expressions in Alyssa's program. 
(define (simple-flatten stream)
  (stream-map 
    stream-car ; <??>    
    (stream-filter (lambda (frame) (not (stream-null? frame))) stream)));<??> stream)))
                   ; alternatively, stream-length, but that makes me uneasy...
    
; b. Does the query system's behavior change if we change it in this way? 
(define (test-4.74)

    (init-query)
    (query '(job ?who ?what))
)
;(test-4.74)
(define simple-stream-flatmap simple-stream-flatmap-4.74) (test-4.74)
    ; doesn't look like it...
    ; still, not sure the (probably tiny) extra performance is worth this extra code/complexity