(define (install-compound-sentences)

    (ambeval-batch
    
        '(define conjunctions '(conjunction and or but))
        
        '(define (parse-compound-sentence)
            (define (maybe-extend sentence)
                (amb
                    sentence
                    (maybe-extend 
                        (list 
                            'compound-sentence
                            sentence
                            (parse-conjunction)
                            (parse-sentence)
                        )
                    )
                )
            )
            (maybe-extend (parse-sentence))
        )
        
        ; THIS one is easy
        '(define (parse-conjunction)
            (list 'conjunction (parse-word conjunctions)))
            
        '(define (parse input)
            (set! *unparsed* input)
            (let ((sent (parse-compound-sentence)))
                (require (null? *unparsed*))
                sent
            )
        )
    
    
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
    
    ;(ambeval-batch '(parse '(the cat eats and the professor sleeps)))
    
    ;(ambeval-batch '(parse '(the cat eats and the professor sleeps but the student studies)))
    

    
    (driver-loop)
)
(test-4.48)