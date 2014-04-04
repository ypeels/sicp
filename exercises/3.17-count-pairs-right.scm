; Traverse the structure, maintaining an auxiliary data structure that is used to keep track of which pairs have already been counted

; laziness: global list + append! will this work?   
     ; CANNOT pass history list as an argument, due to possible branching issues
     ; assume evaluation is single-threaded... (no concurrency/race issues on the history list)
     
(define history '())

(define (in-history? pair)
    (memq pair history))    ; p. 144: (memq item list)
    
(define (add-to-history! x)
    (if (null? history)
        (set! history (list x))         ; stupid cantankerous append!
        (append! history (list x))
    )
)

(define (clear-history!)
    (set! history '()))

(define (count-pairs-3.17 x)

    (cond
        ((not (pair? x))        ; terminal leaf - ben bitdiddle's termination
            0)
        ((in-history? x)        ; new termination: do NOT double-count!!!
            0)  
        (else
            (add-to-history! x)
            (+ 
                (count-pairs-3.17 (car x))
                (count-pairs-3.17 (cdr x))
                1
            )
        )
    )
)


(define (test x)
    (clear-history!)
    (newline)
    (display (count-pairs-3.17 x))
)

(load "3.16-count-pairs-wrong.scm")

(test a3)
(test a4)
(test a7)
(test ainf)
        
    