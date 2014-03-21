; "moar refactoring"

; recursive edition
(define (accumulate combiner null-value term a next b)
    (if (> a b)
        null-value
        (combiner 
            (term a) 
            (accumulate combiner null-value term (next a) next b))))
            
(define (accumulate-iterative combiner null-value term a next b)
    (define (iter x result)
        (if (> x b)
            result
            (iter 
                (next x)
                (combiner result (term x)))))
    (iter a null-value))
            

(define (sum-1.32 term a next b)            (accumulate + 0 term a next b))
(define (product-1.32 term a next b)        (accumulate * 1 term a next b))


(define (sum-iter-1.32 term a next b)       (accumulate-iterative + 0 term a next b))
(define (product-iter-1.32 term a next b)   (accumulate-iterative * 1 term a next b))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; test code, which much be unnested to allow overrides of (sum) and (product). BWAHAHAHAHA i get to reuse old test suites
;(display "\n\noriginal:") (load "1.29-higher-order-functions.scm") (load "1.30-sum-iteratively.scm") (test-1.30)
;(display "\n\n1.32 recursive:") (load "1.29-higher-order-functions.scm") (load "1.30-sum-iteratively.scm") (define (sum term a next b) (sum-1.32 term a next b)) (test-1.30)
;(display "\n\n1.32 iterative:") (load "1.29-higher-order-functions.scm") (load "1.30-sum-iteratively.scm") (define (sum term a next b) (sum-iter-1.32 term a next b)) (test-1.30)
;
;;;(display "\n\noriginal:") (load "1.31-product.scm") (test-1.31) ; meh the output is documented well enough
;(load "1.31-product.scm") (define (product term a next b) (product-1.32 term a next b)) (define (product-iter term a next b) (product-iter-1.32 term a next b)) (test-1.31)

