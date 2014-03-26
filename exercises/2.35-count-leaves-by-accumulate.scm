(load "2.33-37-accumulate.scm")
(load "2.28-fringe-print-leaves.scm") (define enumerate-tree fringe) ; for my "cop-out"...


(define (count-leaves-accum t)
  (accumulate 
    (lambda (L sum) (+ sum (length L)))     ; <??> accumulate operation
    0                                       ; <??> initial value
    
    (map                                    ; flatten the tree into a list, which accumulate can then consume
        (lambda (t) (enumerate-tree t))         ; <??> map operation. not a cop out, is it? i mean, they did it in (sum-odd-squares)...
        t                                       ; <??> target sequence for map
    )
  )
)

; http://community.schemewiki.org/?sicp-ex-2.35
; "Using recursion, it's possible to do it with map and without enumerate-tree"
; I caught a glimpse of their solution but didn't look too closely.
; I guess I should have considered reaching back to that "Mapping over trees" section...
; Here's what I worked out, using the "+ 0" as a starting point.
(define (count-leaves-accum-recur t)
    (accumulate
        +                                   ; <??> accumulate operation. this was my first instinct
        0                                   ; <??> initial value
        (map
            (lambda (subtree)
                ;(display "\n\nlambda ") (display subtree)
                ;(newline) (display (car subtree))
                ;(newline) (display (cdr subtree))
                
                ; actually, it's (fringe) you should be ripping off, NOT (scale-tree)!
                ;(cond 
                ;    ((null? subtree) 0)         ; ignore null leaves
                ;    ((not (pair? subtree)) 1)   ; count non-null leaves
                ;    ((pair? subtree)            ; not a leaf, so recurse
                ;        (+  (count-leaves-accum-recur (car subtree))
                ;            (count-leaves-accum-recur (cdr subtree)))
                ;    )
                ;)
                        
                
                ;(if (pair? subtree)         ; not a leaf
                ;    (+  (count-leaves-accum-recur (list (car subtree)))
                ;        (count-leaves-accum-recur (list (cdr subtree))))
                ;    1
                ;)
                
                ; oh, remember that map TAKES CARE OF TRAVERSAL FOR YOU
                ; and because the (map) is wrapped with an (accum), you are SUMMING OVER THE TREE, not rebuilding it
                (if (pair? subtree)
                    (count-leaves-accum-recur subtree)
                    1
                )
                
            )
            t
        )
    )
)
                    



(define (test-2.35)

    (define (test y)
        (newline) (display y)
        (display "\noriginal: ") (display (count-leaves y))
        (display "\naccum: ") (display (count-leaves-accum y))
        (display "\naccum recursive: ") (display (count-leaves-accum-recur y))
    )
    
    ; from section 2.2.2
    (define (count-leaves x)
      (cond ((null? x) 0)           ; order matters, because by DEFINITION we don't count nil as a leaf - even though you could think of it as a leaf consisting of the empty list
            ((not (pair? x)) 1)         ; this is analogous to how the nil element in a list isn't included in (length)
            (else (+ (count-leaves (car x))
                     (count-leaves (cdr x))))))

    
    (let ((x (cons (list 1 2) (list 3 4))))
        (test x)            ; 4 leaves
        (test (list x x))   ; 8 leaves
    )
)
            

(test-2.35)
