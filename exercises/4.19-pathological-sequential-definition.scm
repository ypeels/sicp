(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (f 10))
  
  ; first run this in mit-scheme
  ; then implement let and run in M-Eval
  
  ; seems like eva needs to do multiple passes, with potentially nontrivial logic
    ; what if you had b(a, c), a, c(a)? then you couldn't just read in reverse order