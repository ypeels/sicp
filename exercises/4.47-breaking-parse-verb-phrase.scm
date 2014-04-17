
(define (install-broken-verb-phrase-parser)
    (ambeval-batch
    
        ; from problem statement
        '(define (parse-verb-phrase)
          ;(display "\nparse-verb-phrase")
          (amb (parse-word verbs)
               (list 'verb-phrase
                     (parse-verb-phrase)
                     (parse-prepositional-phrase))))
    )
)

(define (install-broken-verb-phrase-parser-interchanged)
    (ambeval-batch
    
        ; modified from problem statement
        '(define (parse-verb-phrase)
          ;(display "\nparse-verb-phrase")                    
          (amb (list 'verb-phrase
                     (parse-verb-phrase)
                     (parse-prepositional-phrase))
               (parse-word verbs)))
    )
)


; so why did the original work fine?
(define (install-original-verb-phrase-parser)
    (ambeval-batch
        '(define (parse-verb-phrase)                                    ; first of all, the outer wrapper NEVER recurses
          (define (maybe-extend verb-phrase)
            (amb verb-phrase                                            ; amb branches on the DATA, not on a call to generate data
                 (maybe-extend (list 'verb-phrase
                                     verb-phrase
                                     (parse-prepositional-phrase)))))
          (maybe-extend (parse-word verbs)))                            ; (parse-word verbs) DOES modify *unparsed*, but amb automagically rolls it back during backtracking, right??
    )
)


(define (test-4.47)

    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)

    (load "4.45-49-parsing-natural-language.scm")    
    (install-natural-language-parser)
    
    (install-broken-verb-phrase-parser)
    (install-broken-verb-phrase-parser-interchanged)
    (install-original-verb-phrase-parser)
    
    
    (ambeval-batch '(parse '(the cat eats)))
    ; still fine.
    
    (ambeval-batch '(define (s2) (parse '(the student with the cat sleeps in the class))))
        ; infinite recursion! louis sure knows how to break 'em
    
    (ambeval-batch '(define (s3) (parse '(the professor lectures to the student with the cat))))
    ; should have TWO possible answers.
    
    (driver-loop)
)
(test-4.47)


; "Does this work?"
; PROBABLY not, since Louis proposed it...
; no, it does not work on the test-sentence (s2), due to infinite recursion in (parse-verb-phrase).

; "Does the program's behavior change if we interchange the order of expressions in the amb?"
; yes, now even "the cat eats" causes infinite recursion.
; that's because amb explores alternatives from left to right, and it will ALWAYS try infinite recursion FIRST.



