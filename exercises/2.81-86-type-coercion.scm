(load "2.77-80-generic-arithmetic.scm")

; from ch2.scm
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))
                     
                     

;: (put-coercion 'scheme-number 'complex scheme-number->complex)                     
; this function and (get-coercion were UNIMPLEMENTED in all their sample code...
; i'm gonna hack (get and (put to handle this...and hope there's no name collisions
;(define (get-coercion type1 type2)
;

; but to use existing (get, need to be able to COMBINE SYMBOLS? oh i don't need to convert to function name
                     
                     
(define (test-2.81-86)

    (define (scheme-number->complex n)
      (make-complex-from-real-imag (contents n) 0))
)
