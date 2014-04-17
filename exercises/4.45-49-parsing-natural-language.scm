; from ch4.scm

(define (install-natural-language-parser)

    (ambeval-batch

        ;;;SECTION 4.3.2 -- Parsing natural language

        ;;; In this section, sample calls to parse are commented out with ;:
        ;;; and the output of parses is quoted with '
        ;;; Thus you can load this whole section into the amb evaluator --
        ;;;  (but beware of the exercise 4.47 code, and of redefinitions
        ;;;   of a procedure -- e.g. parse-noun-phrase)

        '(define nouns '(noun student professor cat class))

        '(define verbs '(verb studies lectures eats sleeps))

        '(define articles '(article the a))

        ;; output of parse
        ;'(sentence (noun-phrase (article the) (noun cat)) (verb eats))

        '(define (parse-sentence)
          (list 'sentence
                 (parse-noun-phrase)
                 (parse-word verbs)))

        ;'(define (parse-noun-phrase)
        ;  (list 'noun-phrase
        ;        (parse-word articles)
        ;        (parse-word nouns)))

        '(define (parse-word word-list)
          (require (not (null? *unparsed*)))
          (require (memq (car *unparsed*) (cdr word-list)))
          (let ((found-word (car *unparsed*)))
            (set! *unparsed* (cdr *unparsed*))
            (list (car word-list) found-word)))

        '(define *unparsed* '())

        '(define (parse input)
          (set! *unparsed* input)
          (let ((sent (parse-sentence)))
            (require (null? *unparsed*))
            sent))


        ;: (parse '(the cat eats))
        ;; output of parse
        ;'(sentence (noun-phrase (article the) (noun cat)) (verb eats))

        '(define prepositions '(prep for to in by with))

        '(define (parse-prepositional-phrase)
          (list 'prep-phrase
                (parse-word prepositions)
                (parse-noun-phrase)))

        '(define (parse-sentence)
          (list 'sentence
                 (parse-noun-phrase)
                 (parse-verb-phrase)))

        '(define (parse-verb-phrase)
          (define (maybe-extend verb-phrase)
            (amb verb-phrase
                 (maybe-extend (list 'verb-phrase
                                     verb-phrase
                                     (parse-prepositional-phrase)))))
          (maybe-extend (parse-word verbs)))

        '(define (parse-simple-noun-phrase)
          (list 'simple-noun-phrase
                (parse-word articles)
                (parse-word nouns)))

        '(define (parse-noun-phrase)
          (define (maybe-extend noun-phrase)
            (amb noun-phrase
                 (maybe-extend (list 'noun-phrase
                                     noun-phrase
                                     (parse-prepositional-phrase)))))
          (maybe-extend (parse-simple-noun-phrase)))
          
    )
)


(define (test-4.45-49)
    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    
    (install-natural-language-parser)
    
    (ambeval-batch '(parse '(the cat eats)))
    ; (sentence (noun-phrase (article the) (noun cat)) (verb eats))
    
    (ambeval-batch '(define (s2) (parse '(the student with the cat sleeps in the class))))
    
    (ambeval-batch '(define (s3) (parse '(the professor lectures to the student with the cat))))
    ; should have TWO possible answers.
    
    (driver-loop)
)
;(test-4.45-49)