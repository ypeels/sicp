(load "2.67-70-huffman-encoding-trees.scm")

; from problem statement
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                   (make-leaf 'B 2)
                   (make-code-tree (make-leaf 'D 1)
                                   (make-leaf 'C 1)))))
                                   
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

; plug and chug, high-school style!
(define (test-2.67)
    (display (decode sample-message sample-tree))
    ; (a d a b b c a)
)
; (test-2.67)



