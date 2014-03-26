(load "2.33-37-accumulate.scm")
(load "2.36-accumulate-n.scm")  ; used in problem statement of  transpose


; from problem statement
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
  
  
; and now, "fill in the <??>"
  
  
(define (matrix-*-vector m v)
  (map 
    (lambda (w) (dot-product v w))  ; <??> - w = current row of matrix (v is bound from procedure argument)
    m
  )
)

(define (transpose mat)
  (accumulate-n 
    cons                            ; <??> operation. this works out of the box because (accumulate) operates from RIGHT TO LEFT
    ()                              ; <??> initial value 
    mat
  )
)

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map 
        (lambda (row)               ; <??>  applied to EACH ROW of m, and returns a new row 
            (map 
                (lambda (col)       ;       applied to the jth col in cols and stored via (map) as the jth entry in the new row.
                    (dot-product row col)
                ) 
                cols
            )
        )
        
        m
    )
  )
)


; i DID suspect that we could use matrix*vector...
; but i didn't think you could do it in the same form...
; inspired by http://community.schemewiki.org/?sicp-ex-2.37
(define (matrix-*-matrix-v2 m n)
  (let ((cols (transpose n)))
    (map 
        (lambda (row) (matrix-*-vector cols row))   ; <??>. RIGHT-multiplying the vector row by the matrix cols...
        m
    )
  )
)


; using (matrix-*-vector) by LEFT-multiplying by a matrix
(define (matrix-*-matrix-v3 m n)
    (let ((cols (transpose n)))  
        (transpose                                          ; minor problem: (map) returns a list of column vectors
            (map                                                           ; but a matrix is defined as a list of ROW vectors. (don't notice on m*m', because that result is SYMMETRIC)
                (lambda (col) (matrix-*-vector m col))      ; but THIS i grok. do they teach LEFT-multiplication at MIT? things must be backwards on the east coast
                cols                                        
            )                                                              
        )
    )
)
            
  
  
  
  
  
(define (test-2.37)

    (define (concatenate-cols v times)
        (define (iter result n)
            (if (<= n 0)
                result
                (iter (append result (list v)) (- n 1))
            )
        )
        (transpose (iter () times))
    )
         
    (define (test v m)       
        
    
         (display "\n\nv: ") (display v)
         (display "\nm: ") (display m)
         (display "\nv-cat: ") (display (concatenate-cols v (length m)))
         (display "\nv.v: ") (display (dot-product v v))
         (display "\nm*v: ") (display (matrix-*-vector m v))
         (display "\nm': ") (display (transpose m))
         ;(display "\nm*m: ") (display (matrix-*-matrix m m))
         (display "\nm*m'   : ") (display (matrix-*-matrix m (transpose m)))
         (display "\nm*m' v2: ") (display (matrix-*-matrix-v2 m (transpose m)))
         (display "\nm*m' v3: ") (display (matrix-*-matrix-v3 m (transpose m)))
         (display "\nm*v-cat   : ")    (display (matrix-*-matrix    m (concatenate-cols v (length m))))
         (display "\nm*v-cat v2: ") (display (matrix-*-matrix-v2 m (concatenate-cols v (length m))))
         (display "\nm*v-cat v3: ") (display (matrix-*-matrix-v3 m (concatenate-cols v (length m))))
    )
        
    
    (test (list 1 1 1 1) (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9) ))
    (test (list 1 2 3) (list (list 1 0 0) (list 0 1 0) (list 0 0 1)))
    (test (list 1 2 3) (list (list 0 0 1) (list 0 1 0) (list 1 0 0)))

)
        
; (test-2.37)
