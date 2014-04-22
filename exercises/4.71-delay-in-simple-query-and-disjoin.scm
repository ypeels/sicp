; first instinct: aesthetics? this way only the VERY first element of the combined stream is not delayed
; second instinct: performance? (why pre-evaluate TWO members of the final stream?)
    ; this would be UNDESIRABLE, but not necessarily wrong...

; one remote possibility was that maybe the RULES will have infinite recursion, but straight queries won't?
    ; seemed moot, since the full query evaluator calls (display-stream) at the end...
    ; it'd only make a difference if the EVALUATION of a rule is going to hang forever, not if the result is an infinite stream
        ; AND you'd have to be processing the stream entry by entry, otherwise the evaluator will still crash
    ; empirically, this is pretty much what happens (final example below)
        
        

; code poring: will there be a syntax error without a "true" stream?
    ; well, where does the output of (simple-query) feed into, WOLOG?
        ; ONLY called from (qeval)
            ; hmmmm (qeval) itself is called from (apply-a-rule)? trace further?


; "hints" from text
; 4.4.4.2: "These two streams are combined (using stream-append-delayed, section 4.4.4.6) to make a stream of 
    ; all the ways that the given pattern can be satisfied consistent with the original frame (see exercise 4.71)."
; 4.4.4.2: "The output streams for the various disjuncts of the or are computed separately and merged using the 
    ; interleave-delayed procedure from section 4.4.4.6. (See exercises 4.71 and 4.72.)"
; 4.4.4.6: "This postpones looping in some cases (see exercise 4.71)."
    ; my remote possibility above?

(load "ch4-query.scm")

; louis' version from problem statement
(define (simple-query-4.71 query-pattern frame-stream)
  (stream-flatmap
   (lambda (frame)
     (stream-append (find-assertions query-pattern frame)
                    (apply-rules query-pattern frame)))
   frame-stream))
(define (disjoin-4.71 disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave
       (qeval (first-disjunct disjuncts) frame-stream)
       (disjoin (rest-disjuncts disjuncts) frame-stream))))
       
(define simple-query simple-query-4.71) (define disjoin disjoin-4.71)
       
(init-query)

(query '(job (bitdiddle ben) ?*))
; seems to work fine...

(query '(lives-near ?p1 (hacker alyssa p)))
; fine too...?

(query '(and (lives-near ?p1 (hacker alyssa p)) (job ?p1 ?*)))
(query '(and (job ?p1 ?*) (lives-near ?p1 (hacker alyssa p))))
; both fine

(query '(or (job ?p1 ?*) (lives-near ?p1 (hacker alyssa p))))
; long answer, but still looks fine

;(query '(assert! (rule (eternal-loop) (eternal-loop))))
;(query '(or (job ?p1 ?*) (eternal-loop)))
;(display "never gets here")
    ; will hang forever
    ; still, with the non-louis, fully delayed stream, at least one (job) entry gets displayed before the hang
        ; this is MORE INFORMATIVE from a debugging point of view, since at least the first entry was fine
        ; this would be more valuable if the first entry were a RULE and not just a pattern
 
 
;(query '(assert! (rule (job ?x ?y) (job ?x ?y)))) ; just perverse
;(query '(job (bitdiddle ben) ?*))
;(display "never gets here")
; hmm, this one's pathological EITHER way
    ; with fully delayed streams, you get an infinite OUTPUT loop
    ; with louis' half-delayed stream, you get infinite HANG as apply-rules loops on first application


    