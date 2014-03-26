; I'm not quite sure what the problem is asking for...
; I'll just stop once the listed examples run correctly


(define (fringe tree)

    (cond 
        ((null? tree) ())                     ; exploit: (append list ()) = list
        ((not (pair? tree)) (list tree))
        (else (append (fringe (car tree)) (fringe (cdr tree))))
    )
) ; hey, I found what is pretty much the cleanest solution on http://community.schemewiki.org/?sicp-solutions
  ; HEY this is the same as the BOOK's answer in 2.2.3 (footnote 14)!
  
    
        



(define (test-2.28)
    (let ((x (list (list 1 2) (list 3 4))))
        (newline) (display (fringe x))  ; should be (1 2 3 4)
        (newline) (display (fringe (list x x)))
    )
)

; (test-2.28)
