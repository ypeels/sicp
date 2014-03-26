(load "2.33-37-accumulate.scm")
(load "2.28-fringe-print-leaves.scm") ;(define enumerate-tree fringe) ; for my cop-out...

(define (debug x) "do nothing") 
;(define debug display)


(define (enumerate-tree t)
    (debug "\nenumeratetree\n")
    (let ((L (fringe t)))
        (debug L)
        L
    )
)



(define (count-leaves-accum t)
  (accumulate 
    
    ; <??> accumulate operation
    (lambda (L x) ; damn you, backwards (accumulate) api
        (let ((count (accumulate 
                        ;+ ; this would SUM all the items in L
                        (lambda (y sum) (+ sum 1)) ; this would look better as a separate function, but that wouldn't satisfy the <??> form
                        0 L)))
                        
            (debug count) (debug "\n")   
            (+ x count)
        ) ; x += sum(L)
    )
    
   
            
           
            
    
    
    0           ; <??> initial value


        
    ; maybe map the tree onto a list? or onto a tree of lengths?
    (map        ; target sequence for accumulate
        ; attempted cop out, and does not work.
        ;(lambda (t) (count-leaves-accum t)) 
        
        
        ; can i just cop out and use "fringe"?
        (lambda (t) (enumerate-tree t)); <??> map operation.
        
        t                                   ; <??> target sequence for map
        
        
    )
  )
)



(define (test-2.35)

    (define (test y)
        (newline) (display y)
        (display "\noriginal: ") (display (count-leaves y))
        (display "\naccum: ") (display (count-leaves-accum y))
    )
    
    ; from section 2.2.2
    (define (count-leaves x)
      (cond ((null? x) 0)           ; order matters, because by DEFINITION we don't count nil as a leaf - even though you could think of it as a leaf consisting of the empty list
            ((not (pair? x)) 1)         ; this is analogous to how the nil element in a list isn't included in (length)
            (else (+ (count-leaves (car x))
                     (count-leaves (cdr x))))))

    
    (let ((x (cons (list 1 2) (list 3 4))))
        (test x)
        (test (list x x))
    )
)
            

(test-2.35)
