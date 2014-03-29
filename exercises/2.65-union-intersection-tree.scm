; in the end, we want to represent sets, remember?
; I can think of 2 O(n) ways to do this...
    ; 1. cheapness: unpack to ordered list, use Exercise 2.62 + (intersection-set), and repack to balanced tree
    ; 2. (adjoin-set) followed by balancing. 
        ; but our only balancer is (list->tree, which requires unpack/repack anyway!!
    ; 1. is higher level, so let's just go with that.
; we'll be using the PROCEDURES defined in Exercises 2.63 and 2.64
    ; i guess use the RESULTS that we know they're O(n)?
    

(load "2.62-union-set-ordered.scm")    
(load "2.63-tree-to-list.scm")
(load "2.64-list-to-tree.scm")


(define (union-set-tree s1 s2)
    (cheapness-2.65 s1 s2 union-set))
(define (intersection-set-tree s1 s2)
    (cheapness-2.65 s1 s2 intersection-set))
(define (cheapness-2.65 tree1 tree2 driver)
   (let ((list1 (tree->list-2 tree1)) (list2 (tree->list-2 tree2)))
        (list->tree (driver list1 list2))
    )
)
; wow that is CHEAP!!!
; drawback: the original tree structure will be destroyed.
; but it still meets the customer specification of "set" and "O(n)"!!



(define (test-2.65)

    (define (test t1 t2)
        (display "\n\nunion: ") (display (union-set-tree t1 t2))
        (display "\nintersection: ") (display (intersection-set-tree t1 t2))
    )

    ; balanced trees from Exercise 2.63
    (let (  (t1 '(7 (3 (1 () ()) (5 () ())) (9 () (11 () ()))))
            (t2 '(3 (1 () ()) (7 (5 () ()) (9 () (11 () ())))))
            (t3 '(5 (3 (1 () ()) ()) (9 (7 () ()) (11 () ()))))
            (t4 '(6 (4 (1 () ()) ()) (9 (7 () ()) (10 () ())))))
        
        (test t1 t1)
        (test t1 t2)
        (test t1 t3)
        (test t1 t4)
        ;meh that's enough
    )
)

; (test-2.65)
    
