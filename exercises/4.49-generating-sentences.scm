; not QUITE random sentences, since amb is unseedably deterministic

(define (install-sentence-generator)

    (ambeval-batch
    
        ; uh, now i have to read the problem and the original parser and see just what alyssa means...
    )
)


(define (test-4.49)
    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)

    (load "4.45-49-parsing-natural-language.scm")    
    (install-natural-language-parser)
    
    (install-sentence-generator)
    (parse '(sdlighkfsdg))  ; input is ignored

    
    (driver-loop)
)