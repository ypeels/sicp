(load "2.63-65-sets-as-binary-trees.scm")

; from problem statement
(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))                       ; (n-1)/2 guarantees nonzero remainder. quotient: integer division. 
        (let ((left-result (partial-tree elts left-size)))          ; make left subtree (need to know length left-size). passes the WHOLE list to the left!
          (let ((left-tree (car left-result))                       ; extract left subtree and remainder
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))                 ; right-size = n - left-size - 1 (current); could have been defined before this let (it just needed left-size)
            (let ((this-entry (car non-left-elts))                  ; current node is first of remainder
                  (right-result (partial-tree (cdr non-left-elts)   ; make right subtree from rest of remainder
                                              right-size)))
              (let ((right-tree (car right-result))                 ; extract right subtree and remainder
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)   ; result (tree . remainder)
                      remaining-elts))))))))    

; in any NORMAL language, setting a local variable would NOT increase indentation
; - this should  just be a simple linear flow...not this nested nightmare...                     
                      
; passing the remainder back is CRUCIAL, because the ENTIRE remaining list is included in every recursive call.
                      
; (car result) and (cdr result) never fail because results are always PACKED PAIRS (tree . remainder)

; but how does it magically keep the tree ORDERED?? well...
    ; elements are always pulled off using (car
    ; the element list is always passed to the left first
    ; so it stands to reason that elements to the left will be less than elements to the right...



(define (test-2.64)
    (define (test . L)
        (newline)
        (display (list->tree L))
    )
    
    (test 1)
    (test 1 2)
    (test 1 2 3)
    (test 1 3 5 7 9 11) 
)

(test-2.64)

; Exercise 2.64a paragraph
; 1. Take the first "half" of the list and make the left subtree.
; 2. Use the median element as the root node.
; 3. Take the rest of the list and make the right subtree.
; The entire process occurs recursively in steps 1 and 3.
; Due to "(n-1)/2", any imbalance will result in more elements to the right ("right-leaning").
; Because elements are pulled off from the left of the list and recursion goes left on the tree first,
; the tree will preserve any "left-to-right" ordering present in the list.

; my guess for 1 3 5 7 9 11
; (length-1)/2 = 5/2 = 2. 
; so (1 3) gets passed to the left, and the root node is 5.

;          5
;        1   9
;         3 7 11. confirmed by running.

; Exercise 2.64b
; I'm gonna guess O(n) again, since there is one (cons occurring per node (even terminal ones)