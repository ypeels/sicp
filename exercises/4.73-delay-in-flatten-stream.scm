; renamed from problem statement
(define (flatten-stream-4.73 stream)
  (if (stream-null? stream)
      the-empty-stream
      (interleave
       (stream-car stream)
       (flatten-stream-4.73 (stream-cdr stream)))))

      
; from my notes, (flatten-stream) is intended to flatten a stream of streams
    ; i.e., (stream-car stream) is itself a stream

    
; interleave itself is given by
;(define (interleave s1 s2)
;  (if (stream-null? s1)
;      s2
;      (cons-stream (stream-car s1)
;                   (interleave s2 (stream-cdr s1)))))   
; so like (append-stream), the result IS a stream, but the first element of s2 has been evaluated    

; whereas interleave-delayed is given by
;(define (interleave-delayed s1 delayed-s2) 
;  (if (stream-null? s1)                    
;      (force delayed-s2)
;      (cons-stream
;       (stream-car s1)
;       (interleave-delayed (force delayed-s2)
;                           (delay (stream-cdr s1))))))


; the answer to THIS exercise should be the same as to 4.71
    ; aesthetically, super-lazy evaluation of stream members makes more sense
    ; if the (stream-cdr) is going to hang forever during EVALUATION, at least you'll get the (stream-car)


 
    
       

(load "ch4-query.scm")
;(define flatten-stream flatten-stream-4.73)
(init-query)
(query '(job ?who ?what))
; the system itself seems ok with this... (no infinite loops)

; to come up with an example, you'd need to formulate a query that generates multiple frames
    ; ah, isn't that what happens with an (and)? (the second query examines all frames from the first)
(query '(assert! (rule (infinite-loop) (infinite-loop))))
(query '(assert! (rule (job (Bitdiddle Ben) ?what) (infinite-loop))))
(query '(and (supervisor ?slave ?master) (job ?master ?what)))

; with non-delayed (interleave)
;(and (supervisor (aull dewitt) (warbucks oliver)) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (cratchet robert) (scrooge eben)) (job (scrooge eben) (accounting chief accountant)))
;(and (supervisor (scrooge eben) (warbucks oliver)) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (bitdiddle ben) (warbucks oliver)) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (reasoner louis) (hacker alyssa p)) (job (hacker alyssa p) (computer programmer)))
;(and (supervisor (tweakit lem e) (bitdiddle ben)) (job (bitdiddle ben) (computer wizard)))
;... aborted
;Aborting!: maximum recursion depth exceeded


; with delayed (interleave) - you get ONE extra answer before the crash.
;;; Query results:
;(and (supervisor (aull dewitt) (warbucks oliver)) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (cratchet robert) (scrooge eben)) (job (scrooge eben) (accounting chief accountant)))
;(and (supervisor (scrooge eben) (warbucks oliver)) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (bitdiddle ben) (warbucks oliver)) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (reasoner louis) (hacker alyssa p)) (job (hacker alyssa p) (computer programmer)))
;(and (supervisor (tweakit lem e) (bitdiddle ben)) (job (bitdiddle ben) (computer wizard)))
;(and (supervisor (fect cy d) (bitdiddle ben)) (job (bitdiddle ben) (computer wizard)))
;... aborted
;Aborting!: maximum recursion depth exceeded

;(query-driver-loop)
