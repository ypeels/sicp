; there's no WAY i'm gonna do 5.51 or 5.52
; this is the end of the line for me
; and i do NOT feel like modifying ch5-compiler.scm if i can avoid it
; instead, i'll modify mceval to avoid, e.g., compiling (let)

(load "5.50-mceval-simplified.scm")


(define apply-in-underlying-scheme '*undefined-aius*) ; hmm, can't be part of mceval-text??
(define the-global-environment '*undefined-tge*)

; reality check / regression test
(define (test-mceval)
    (set! apply-in-underlying-scheme apply) ; must precede mceval-text, else apply gets overwritten
    (eval mceval-text user-initial-environment)    
    (set! the-global-environment (setup-environment)) ; must follow mceval-text, else (setup-env) is undefined
    
    (define (mceval expr)
        (prompt-for-input ";;; Input from batch file")
        (user-print expr)
        (newline)
        
        (announce-output output-prompt)
        (user-print (eval expr the-global-environment))
    )
    
    (mceval '(begin
        (define (factorial n)
            (if (= n 1)
                1
                (* n (factorial (- n 1)))))
        (factorial 5)
    ))
    
    (driver-loop)
)
(test-mceval)