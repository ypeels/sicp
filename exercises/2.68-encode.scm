(load "2.67-70-huffman-encoding-trees.scm")

; from problem statement
(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))
              
              
              
; "returns the list of bits that encodes a given symbol according to a given tree"
(define (encode-symbol s tree)     ; function signature from (encode
                                   ; also, should return encoded bits as a list of 1's and 0's

    (define (node-has-symbol? sym node)
        (memq sym (symbols node)))

    (define (encode-symbol-main s tree)
        (if (leaf? tree)
            '()                                         ; no more left/right branches to follow, no more bits to append.
            (let (  (left-node (left-branch tree))      ; by construction, every non-leaf has a left and right branch.
                    (right-node (right-branch tree)))
                (if (node-has-symbol? s right-node)
                    (cons 1 (encode-symbol-main s right-node))
                    (cons 0 (encode-symbol-main s left-node))
                )
            )
        )
    )
    
    ; "signals an error if the symbol is not in the tree at all"
    ; since each node of the tree contains all symbols below, you can do this at the OUTSET.
    (if (not (node-has-symbol? s tree))
        (error "Symbol not found in tree" s (symbols tree))
        (encode-symbol-main s tree))
)



(define (test-2.68)
    (load "2.67-sample-messages.scm")
    (let ((bits-2.68 (encode '(a d a b b c a) sample-tree)))
        (display bits-2.68)
        (if (not (equal? bits-2.68 sample-message))
            (error "You fail it" bits-2.68 sample-message)
            (display "You win!")
        )
    )
)

;(test-2.68)