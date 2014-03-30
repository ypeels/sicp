(load "2.68-encode.scm")
(load "2.69-generate-huffman-tree.scm")

; (make-leaf-set uses (adjoin-set, which maintains the set as an ordered list.
; so the input pair list need not be ordered!!
(define pairs '((a 2) (boom 1) (get 2) (job 2) (na 16) (sha 3) (yip 9) (wah 1)))
(define tree (generate-huffman-tree pairs))
(define message 
    '(  Get a job
        Sha na na na na na na na na
        Get a job
        Sha na na na na na na na na
        Wah yip yip yip yip yip yip yip yip yip
        Sha boom))

(define coded-message (encode message tree))
(display "\nCoded message: ")
(display coded-message)
(display "\nCoded message length: ")                            ; 84
(display (length coded-message))
(display "\nEquivalent fixed-length 3-bit message length: ")    ; 108    
(display (* 3 (length message)))