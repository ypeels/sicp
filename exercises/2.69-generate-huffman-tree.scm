(load "2.67-70-huffman-encoding-trees.scm")

; from problem statement
(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))
  
  
; (display (make-leaf-set '((A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1))))
; '((leaf h 1) (leaf g 1) ... (leaf b 3) (leaf a 8))


; function signature from (generate-huffman-tree
; repeatedly call (make-code-tree to merge nodes
    ; take advantage of (weight, which works on trees and leaves alike
; basic algorithm in "Generating Huffman trees"
; "You can take significant advantage of the fact that we are using an ordered set representation."
    ; remove first 2 elements, merge, then use ordered-set adjoin
    ; hey, lookit that, (adjoin-set is naturally ordered
    
(define (successive-merge ordered-list)
    (if (<= (length ordered-list) 1)
        (car ordered-list)                                      ; don't forget to extract the one and only tree!
        (let (  (first-item (car ordered-list))                 ; just pull first 2 elems of ordered list in ASCENDING order
                (second-item (cadr ordered-list))
                (remaining-items (cddr ordered-list)))
            (successive-merge
                (adjoin-set                                     ; (adjoin-set maintains ordered list! mighty generous
                    (make-code-tree first-item second-item)     ; "heavy lifting" delegated to (make-code-tree.
                    remaining-items                             
                )
            )
        )
    )
)


(define (test-2.69)
    (define (test pairs)
        (newline) (display pairs)
        (newline) (display (generate-huffman-tree pairs))
        (newline)
        (newline)
    )
    
    ;(test '((A 4) (B 2) (C 1) (D 1)))
    ;(test '((A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1))) ; output is HARD to read


    (load "2.67-sample-messages.scm")
    (load "2.68-encode.scm")
    
    (display sample-tree) (newline)
    (display (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1)))) (newline)
    
    ; how about checking that you have a valid tree for encoding and decoding?
    (let ((tree (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1)))))
        (newline)
        (if (equal? '(a d a b b c a) (decode (encode '(a d a b b c a) tree) tree)) 
            (display "Decode-encode checks!")
            (error "Decode-encode failed!")
        )
        (newline)
        (if (equal? sample-message (encode (decode sample-message tree) tree))
            (display "encode-decode checks!")
            (error "encode-decode fails")
        )
    )
)

;(test-2.69)


        
    
    

    