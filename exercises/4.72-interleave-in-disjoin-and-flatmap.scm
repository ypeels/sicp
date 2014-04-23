(define (disjoin-4.72 disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (stream-append-delayed ;(interleave-delayed
       (qeval (first-disjunct disjuncts) frame-stream)
       (delay (disjoin-4.72 (rest-disjuncts disjuncts)
                       frame-stream)))))
                       
(define (flatten-stream-4.72 stream)
  (if (stream-null? stream)
      the-empty-stream
      (stream-append-delayed ;(interleave-delayed
       (stream-car stream)
       (delay (flatten-stream-4.72 (stream-cdr stream))))))
       
(load "ch4-query.scm")
(define disjoin disjoin-4.72) (define flatten-stream flatten-stream-4.72) ; <---------
(init-query)
;(query '(lives-near ?p1 ?p2))
; system still seems to work correctly

; the reason for interleave is probably the same as the reason for delay in 4.71
; if one of the result streams is infinite (bugged?), you'll still get all the output from the following streams
    ; esp maybe if an infinite stream is EXPECTED, but the info from the other streams is what matters...

; (Hint: Why did we use interleave in section 3.5.3?)
    ; because the streams there were infinite! without interleaving, you'd NEVER see a second stream

; ohhhhh probably because often you're using logic programming for NEW INFERENCES (e.g. 4.61) 
    ; not necessarily querying an old existing database
    ; and any time you're writing fresh code, every bit of debugging-friendly functionality helps.

;(query '(assert! (rule (eternal-loop) (eternal-loop))))
;(query '(or (job ?p1 ?*) (eternal-loop)))
; hmm, not sure about this case, since only ONE job displays in the normal system, but ALL jobs in the modified...

;(query '(assert! (rule (job ?person ?what) (job ?person ?what))))
;(query '(or (job ?p1 ?*) (supervisor ?p1 ?p2)))
; hmm i am having trouble coming up with a concrete example that runs differently...

;(query '(lives-near ?who (Bitdiddle Ben)))
;(query '(or (supervisor ?who (Bitdiddle Ben)) (lives-near ?who (Bitdiddle Ben)))) ; gives spurious answers!


; what about the sols/text example?
;(query '(assert! (married Mickey Minnie)))
;(query '(assert! (rule (married ?x ?y) (married ?y ?x))))
;(query '(married Mickey Minnie))


; aesthetically, this is closer to the "simultaneous parallel evaluation" of all the disjuncts...
    

; well, the 4.71 examples where the query EVALUATION hangs forever are not QUITE suitable
    ; you get MORE information out of the system by evaluating the second disjunct later
; need a query which has a disjunct with infinite results...

(query '(or (supervisor ?who (Bitdiddle Ben)) (lives-near ?who2 (Bitdiddle Ben))))
; non-interleaved
;(or (supervisor (tweakit lem e) (bitdiddle ben)) (lives-near ?who2 (bitdiddle ben)))
;(or (supervisor (fect cy d) (bitdiddle ben)) (lives-near ?who2 (bitdiddle ben)))
;(or (supervisor (hacker alyssa p) (bitdiddle ben)) (lives-near ?who2 (bitdiddle ben)))
;(or (supervisor ?who (bitdiddle ben)) (lives-near (aull dewitt) (bitdiddle ben)))
;(or (supervisor ?who (bitdiddle ben)) (lives-near (reasoner louis) (bitdiddle ben)))
; well, if there were thousands of entries in each stream, you'd probably want to see
    ; the answers interleaved instead of all of the first query then all of the second query
    ; i mean, if you wanted the latter, you'd just run TWO SEPARATE QUERIES

; how about just a simple query, since (simple-query) uses flatmap?
; no... since the flatmap there is applied only to a singleton empty frame...
;(query '(assert! (rule (job ?person ?what) (job ?what ?person))))
;(query '(job ?p1 ?*))


; less clear how to get a good flatmap example, since it's used by so many other special forms... meh

; sols just mention infinite streams
; i guess if you ever DO generate an infinite stream somewhere, you would want to interleave
; it's not quite clear how you would generate and display one without hanging on it...?

;(query '(assert! (married Mickey Minnie)))
;(query '(assert! (married Donald Daisy)))
;(query '(assert! (rule (married ?x ?y) (married ?y ?x))))
;(query '(or (married Mickey ?who) (married Donald ?who2)))
; ok, here you go: without interleaving, you'll never see results for Donald/Daisy - it'll hang on Mickey/Minnie
