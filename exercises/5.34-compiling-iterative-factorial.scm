(load "5.33-38-compiling-to-file.scm")

(define (compile-fact-iter)
    (compile-to-file
        '(define (factorial n)
          (define (iter product counter)
            (if (> counter n)
                product
                (iter (* counter product)
                      (+ counter 1))))
          (iter 1 1))
        'val
        'next
        "5.34-factorial-iterative.txt"
    )
)

(compile-fact-iter)