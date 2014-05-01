(load "5.26-29-eceval-batch.scm")

(define (eceval-prebatch-command) 
    '(define (f n) ;(factorial n)
      (define (iter product counter)
        (if (> counter n)
            product
            (iter (* counter product)
                  (+ counter 1))))
      (iter 1 1))
)

(run-eceval)