; no auxiliary output variable...
(define (reverse-scheming L)

    ; gets order right, but nesting is wrong, and you can't get the () terminator in easily at all
    ;(if (null? (cdr L))        
    ;    (car L)
    ;    (cons (reverse (cdr L)) (car L)))
    
    ; scheming, but all the extra calls to "list" seem bad...
    (if (null? (cdr L))
        (list (car L))
        (append (reverse (cdr L)) (list (car L))))
        
)


; my instinct as a C++ programmer
(define (reverse-by-indexing L)
    (define (iter result n)
        (cond
            ((< n 0) result)    ; termination
            (else
                (append                     
                    (list (list-ref L n))
                    (iter result (- n 1)) 
                )
            )   
        )
    )
    (iter () (- (length L) 1)) 
)


; fine, but how about doing this without (list) or (append)?!
; wait, think about the list definition on p. 100
(define (reverse-iter input-list)
    
    (define (iter result L)
        (if (null? L)
            result
            (iter
                (cons (car L) result)       ; "feels" wrong, but that's just the nature of the nesting on p. 100
                (cdr L)
            )
        )
    )
    
    (iter () input-list)
)



            
        
        
        
         
(define (test-2.18)
    (newline)   ; (reverse) is a built-in! stop confusing me!!!
    
    (define (test reverse-procedure title)
        (newline)
        (display title)
        (display ": ")
        (display (reverse-procedure (list 1 4 9 16 25)))
    )
    
    (test reverse "built-in")
    (test reverse-scheming "reverse-scheming - no auxiliary output variable")
    (test reverse-by-indexing "reverse-by-indexing - the silliest of all")
    (test reverse-iter "reverse-iter - cons/car/cdr/null? only, but with auxiliary output variable")

)

; (test-2.18)