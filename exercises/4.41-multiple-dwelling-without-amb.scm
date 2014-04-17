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
  (filter (lambda (x) (not (= x item))) ; (equal? x item))) ; can generalize to all sets, not just numerical
          sequence)) 
               
               
; new code. (should be SHORT, aside from the data entry)               
(define (valid? dwelling-list)
    (let (  (baker      (list-ref dwelling-list 0))
            (cooper     (list-ref dwelling-list 1))
            (fletcher   (list-ref dwelling-list 2))
            (miller     (list-ref dwelling-list 3))
            (smith      (list-ref dwelling-list 4))
            )
        (and   
            (not (= baker 5))
            (not (= cooper 1))
            (not (= fletcher 5))
            (not (= fletcher 1))
            (> miller cooper)
            (not (= (abs (- smith fletcher)) 1))    ; can comment out to reproduce 4.38, if desired
            (not (= (abs (- fletcher cooper)) 1))
        )
    )
)

; (permutations) automatically filters for (distinct?)
(display (filter valid? (permutations '(1 2 3 4 5))))
; ((3 2 4 5 1))