; "Our implementation of and as a series combination of queries (figure 4.5) is elegant, but it is inefficient"
    ; i'd characterize SCHEME itself as "elegant, but inefficient", with respect to programmer time
    
(define (install-and-4.76)
    (put 'and 'qeval conjoin-4.76))
    
    
;(define (conjoin conjuncts frame-stream)              
;  (if (empty-conjunction? conjuncts)                  
;      frame-stream    
;      (conjoin (rest-conjuncts conjuncts)             
;               (qeval (first-conjunct conjuncts)      
;                      frame-stream))))    
    
; must have same signature as (conjoin)
(define (conjoin-4.76 conjuncts frame-stream)

    ; iterate over the list of streams. each stream is a stream of frames.
        ; if there is only 1 stream left, the merging is done! return.
        ; for the first 2 streams, loop over all entries in BOTH (nested stream-flatmap or something?)
            ; accumulate any successful merges of frames
    ;(define (iter 
    
        

    ; process the ... clauses of the and separately, then look for all pairs of output frames that are compatible
    
    (let ((evaluated-conjuncts (map (lambda (c) (qeval c frame-stream)) conjuncts)))
        ; each member of the list evaluated-conjuncts is a stream of frames.
)


; "You must implement a procedure that takes two frames as inputs, 
; checks whether the bindings in the frames are compatible, 
; and, if so, produces a frame that merges the two sets of bindings.
; This operation is similar to unification."
; leverage existing API?
    ; for all bindings in f1, try to extend f2 via (extend-if-possible)
        ; need to signal error if (extend-if-possible) failed...
; how do i loop over a frame?
    ; from (extend), a frame is just a list of (var . value) pairs.
(define (merge-if-possible source-frame dest-frame)
    (cond 
        ((eq? dest-frame 'failed) 'failed-merge)
        ((null? source-frame) dest-frame)
        (else
            (let (  (first-binding (car source-frame))
                    (rest-bindings (cdr source-frame))   
                    )
                (merge-if-possible
                    rest-bindings
                    (extend-if-possible ; var val frame
                        (binding-variable first-binding)
                        (binding-value first-binding)
                        dest-frame
                    )
                )
            )
        )
    )
)
        
               
                    
                



    
(define (test-4.76)

    (load "ch4-query.scm")
    (init-query)
    (install-and-4.76) ; should overwrite ('and 'qeval conjoin) in table.
    
    ; just a regression test, for lack of creativity
    (query '(and (job ?who ?what) (supervisor ?who (warbucks oliver))))
)
(test-4.76)