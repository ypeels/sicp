(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (f 10))
  
  ; first run this in mit-scheme
  ; then implement let and run in M-Eval