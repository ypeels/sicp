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
    
        '(define adjectives '(adjective quick brown lazy))
        '(define adverbs '(adverb tardily brilliantly industriously))
        
        ; for simplicity, let's have adverbs FOLLOW verbs and adjectives precede nouns.
            ; the latter is actually a BIT harder, because it has to come between articles and nouns.
                ; COULD redefine articles as either article or article+adj, but that seems like a cop-out...?
                    ; ugh, the alternative disrupts nouns too much, esp considering there is already "noun-phrase" with prepositional phrases...
            ; TODO: 
                ; adverbs modifying adjectives
                ; adverbs placed rather arbitrarily in the sentence
                
        '(define (parse-verb-phrase)
          (define (maybe-extend verb-phrase)
            (amb verb-phrase
            
                 ; just add a new possibility, methinks 
                 (maybe-extend 
                    (list 
                        'verb-phrase
                        verb-phrase
                        (parse-word adverbs)
                    )
                 )                        
            
                 (maybe-extend (list 'verb-phrase
                                     verb-phrase
                                     (parse-prepositional-phrase)))))        
           (maybe-extend (parse-word verbs)))                                     
                
                 
                 ; adjectives need TWO modifications!
        '(define (parse-adjective-list)
            (define (maybe-extend adjective)
                (amb
                    adjective
                    (maybe-extend
                        (list 
                            'adjective-list
                            adjective
                            (parse-word adjectives)
                        )
                    )
                )
            )
            (maybe-extend (parse-word articles)) ; adj list currently MUST start with an article (meh)
        )
        
        ; sols just made this amb(article+noun, article+adj+noun) - not allowing for multiple adjectives. http://community.schemewiki.org/?sicp-ex-4.48
        '(define (parse-simple-noun-phrase)
          (list 'simple-noun-phrase
                (parse-adjective-list);(parse-word articles)
                (parse-word nouns)))
                        
          
         
    
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
    
    
    (install-adjectives-adverbs)
    (ambeval-batch '(parse '(the student eats brilliantly and the lazy professor sleeps)))
    
    (ambeval-batch '(parse '(the quick brown student eats brilliantly and the lazy professor sleeps tardily industriously)))

    
    (driver-loop)
)
;(test-4.48)