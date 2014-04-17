(load "2.40-43-flatmap.scm")

; from chapter 2! i knew i saw this somewhere.
(define (permutations s)
  (if (null? s)                    ; empty set?
      (list nil)                   ; sequence containing empty set
      (flatmap (lambda (x)
                 (map (lambda (p) (cons x p))
                      (permutations (remove x s))))
               s)))
 
(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence)) 
               
               
; new code (should be short)               
; first test (permutations '(1 2 3 4 5))
