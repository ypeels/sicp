(load "2.33-37-accumulate.scm")
(define nil ())

; from problem statement
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init     (map (lambda (LL) (car LL)) seqs)) ; first elements <??>)
            (accumulate-n op init   (map (lambda (LL) (cdr LL)) seqs)) ; remaining elements <??>)
      )
  )
)
            
            
            
(define (test-2.36)

    (define (test nested-list)
        (newline)
        (display nested-list) (newline)
        (display (accumulate-n + 0 nested-list)) (newline)
    )
    
    
    ; ((1 2 3) (4 5 6) (7 8 9) (10 11 12))
    (test (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))    ; should be (22 26 30)
)

; (test-2.36)
