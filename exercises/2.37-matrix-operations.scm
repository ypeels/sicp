(load "2.33-37-accumulate.scm")
(load "2.36-accumulate-n.scm")  ; for transpose


; from problem statement
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
  
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
    (map                            ; for each ROW of m, apply <??>, which returns a new row (unless there's recursion...)     
        
        ; how about we "cheat" and add ANOTHER ARGUMENT to map? no, would only compute diagonal elements...
        
        ; <??> WANT to multiply current row with the kth column...
        (lambda (row) (map (lambda (col) (dot-product row col)) cols))
        
        m
    )
  )
)
  
  
  
  
(define (test-2.37)

         
    (define (test v m)    
         (display "\n\nv: ") (display v)
         (display "\nm: ") (display m)
         (display "\nv.v: ") (display (dot-product v v))
         (display "\nm*v: ") (display (matrix-*-vector m v))
         (display "\nm': ") (display (transpose m))
         (display "\nm*m: ") (display (matrix-*-matrix m m))
    )
        
    
    (test (list 1 1 1 1) (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9) (list 0 0 0 0)))
    (test (list 1 2 3) (list (list 1 0 0) (list 0 1 0) (list 0 0 1)))
    (test (list 1 2 3) (list (list 0 0 1) (list 0 1 0) (list 1 0 0)))

)
        
(test-2.37)
