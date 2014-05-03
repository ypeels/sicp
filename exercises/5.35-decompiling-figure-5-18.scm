(load "ch5-compiler.scm")

; cf p. 591
(display "hello world")
(define filename "5.35-decompiling-figure-5-18.txt")
(define file (open-output-file filename #f)); second argument is append
;(display 
(define compiled-expression
    (compile
        '(define (f x) (+ x (g (+ x 2))))   ; my answer from the asm reading
        'val
        'next
    )
    ;file ; unreadable, whether here or at the command prompt...but i can fix that!
)

; ok, now i need to output the result list ITEM BY ITEM

;(define (print x) (display x)) ; for testing
(define (print x) (display x file))
(define (display-result object-code-listing)
    (if (null? object-code-listing)
        'done
        (let ((current-line (car object-code-listing)))
            (if (list? current-line)
                (print "  ") ; get spacing right - statements are indented, but labels are not
            )
                
            (print current-line)
            (print "\n")
            
            (display-result (cdr object-code-listing))
        )
    )
)
(display-result (statements compiled-expression)) ; first 2 entries are needed and modified registers for the whole chunk of object code
; the result is identical to Figure 5.18, except for label numbers
    ; i can only presume that their label numbering comes from the fact that this was a subexpression?


(display "\nResults output to ") (display filename)

(close-all-open-files)

(display "\ngoodbye world - never gets here?")
