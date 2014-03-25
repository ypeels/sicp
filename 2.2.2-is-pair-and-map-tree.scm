(display "\nIllustrating the primitive predicate (pair?)\n")
(display (pair? (cons 1 2))) (newline)   ; #t
(display (pair? 1))          (newline)   ; #f
(display (pair? (list 1)))   (newline)   ; #t because (list 1) = (cons 1 ())
(display (pair? ()))         (newline)   ; #f    



                 
(display "\nDemonstrating the book's (count-leaves) procedure\n")

(define (count-leaves x)
  (cond ((null? x) 0)           ; order matters, because by DEFINITION we don't count nil as a leaf - even though you could think of it as a leaf consisting of the empty list
        ((not (pair? x)) 1)         ; this is analogous to how the nil element in a list isn't included in (length)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))
                 
(define x (cons (list 1 2) (list 3 4)))
(display x) (newline)                           ; ((1 2) 3 4). notice how (cons) PRE-APPENDS to a list
(display (length x)) (newline)                  ; 3
(display (count-leaves x)) (newline)            ; 4
(display (length (list x x))) (newline)         ; 2
(display (count-leaves (list x x))) (newline)   ; 8






(display "\nIterating through a tree manually vs. using (map). NOT very different...\n")
(define nil ())

(define (scale-tree tree factor)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (* tree factor))
        (else (cons (scale-tree (car tree) factor)
                    (scale-tree (cdr tree) factor)))))
                    
(define (scale-tree-map tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)               ; Difference #1: no need to check for (null?), since (map) applies only to non-null list members.
             (scale-tree sub-tree factor)   ; Difference #2: (map) automatically extracts and rebuilds list elements, so no need for (car), (cdr), (cons)
             (* sub-tree factor)))
       tree)) 
       
(define tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))
(define factor 10)
(display (scale-tree tree factor)) (newline)
(display (scale-tree-map tree factor)) (newline)