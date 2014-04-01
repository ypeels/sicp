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
(define (get-coercion type1 type2)
    (get
        (symbol-append type1 '-> type2) ; op
        (list type1 type2)              ; type
    )
)

(define (put-coercion type1 type2 proc)
    (put
        (symbol-append type1 '-> type2)
        (list type1 type2)
        proc
    )
)

                     
                     
(define (test-2.81-86)

    (define (scheme-number->complex n)
      (make-complex-from-real-imag (contents n) 0))
      
    (put-coercion 'scheme-number 'complex scheme-number->complex)                     
    
    (newline)
    (display (scheme-number->complex (make-scheme-number 3.1)))
)
