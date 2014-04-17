; not QUITE random sentences, since amb is unseedably deterministic

(define (install-sentence-generator)

    (ambeval-batch
    
    
        ; "by simply changing the procedure parse-word so that it ignores the ``input sentence'' and 
        ; instead always succeeds and generates an appropriate word, we can use the programs we had 
        ; built for parsing to do generation instead
        '(define (parse-word word-list)
            
            ; ignore *unparsed* and have no requirements
            ; just pick SOME word from word-list.
            ; the (maybe-extend)'s should automagically do the rest.
            ; this simple idea gets stuck in "the student for the student for the student..." infinite length
                ; that is, without the next 2 lines, from the original solution.
            
            ; sol uses the input sentence to tick down a length? meh, i have no better idea, so let's use that.
            (require (not (null? *unparsed*)))
            (set! *unparsed* (cdr *unparsed*))
            ; sols were overly restrictive in that they required the input to be a RECOGNIZABLE SENTENCE pulled from the word banks
                
            ;(list
            ;    (car word-list) ; still need part of speech tag!? don't really know why, don't care
            ;    (list-ref word-list (an-integer-between 1 (- (length word-list) 1)))
            ;)            
            ; this works fine, but tags still get tacked on by (parse-simple-noun-phrase, etc.)
            (list-ref word-list (an-integer-between 1 (- (length word-list) 1))) ; this didn't work. meh.
            
            
        )
                
    )
)


(define (test-4.49)
    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    (load "4.35-an-integer-between-by-amb.scm")
    (install-integer-between)

    (load "4.45-49-parsing-natural-language.scm")    
    (install-natural-language-parser)
    
    (install-sentence-generator)
    
    ;(ambeval-batch '(define (t) (parse '(the cat studies))))  ; input is ignored    
    (ambeval-batch '(define (t) (parse '(1 2 3))))
    ;the student studies
    ;the student lectures
    ;the student eats
    ;the student sleeps
    ;the professor studies 
    ;etc.
    
    ;(ambeval-batch '(define (t) (parse '(1 2 3 4 5 6 7)))) ; this hung. needs to be a well-formed number of words?
    
    (ambeval-batch '(define (t) (parse '(1 2 3 4 5 6 7 8 9)))) ; needs to be a well-formed number of words?
    ;the student studies for the student for the student
    ;the student studies for the student for the professor
    ;the student studies for the student for the cat [good for them]
    ;the student studies for the student for the class
    ;the student studies for the student for a student
    
    
    

    
    (driver-loop)
)
;(test-4.49)