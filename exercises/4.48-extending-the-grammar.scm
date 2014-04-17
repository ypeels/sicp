(define (install-compound-sentences)

    (ambeval-batch
    
        '(define conjunctions '(conjunction and or but))
        
        
        ; this defines a compound sentence as either a simple sentence, or a sentence extended by a conjunction + new sentence
        ; loops back to allow for third, fourth, etc. run on sentences, the same way (parse-verb-phrase) does.
            ; and what is that way, exactly??
                ; ohhhh the entire compound sentence is treated as a SINGLE sentence by recursion
                ; then (maybe-extend) checks again for another trailing conjunction
                ; this means that the left-most sentence should be the most deeply nested. yep!
        '(define (parse-compound-sentence)
            (define (maybe-extend sentence)
                (amb
                    sentence
                    (maybe-extend 
                        (list 
                            'compound-sentence
                            sentence
                            (parse-word conjunctions) ;(parse-conjunction)
                            (parse-sentence)
                        )
                    )
                )
            )
            (maybe-extend (parse-sentence))
        )
        
        ; THIS one is easy? actually, unnecessary for single-word entities, like articles!
        ;'(define (parse-conjunction)
        ;    (list 'conjunction (parse-word conjunctions)))
            
        '(define (parse input)
            (set! *unparsed* input)
            (let ((sent (parse-compound-sentence)))
                (require (null? *unparsed*))
                sent
            )
        )
    
    
    )
)

(define (install-adjectives-adverbs)
    (ambeval-batch
    
        '(define adjectives '(quick brown lazy))
        '(define adverbs '(tardily brilliantly industriously))
        
        ; for simplicity, let's have adverbs precede verbs and 
    
    )
)


(define (test-4.48)
    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)

    (load "4.45-49-parsing-natural-language.scm")    
    (install-natural-language-parser)
    
    (install-compound-sentences)
    
    (ambeval-batch '(parse '(the cat eats))) ; this better still work
    
    (ambeval-batch '(parse '(the cat eats and the professor sleeps)))
    
    ; this works, surprisingly...
    (ambeval-batch '(parse '(the cat eats and the professor sleeps but the student studies)))
    

    
    (driver-loop)
)
(test-4.48)