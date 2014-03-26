(load "2.33-37-accumulate.scm")
(load "2.36-accumulate-n.scm")  ; for transpose


; from problem statement
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
  
(define (matrix-*-vector m v)
  (map <??> m))
  
  
  
  
(define (test-2.37)

         
    (define (test v m)    
         (display "\nv: ") (display v)
         (display "\nm: ") (display m)
         (display "\nv.v: ") (display (dot-product v v))
    )
        
    
    (test (list 1 1 1 1) (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9)))
)
        
(test-2.37)
