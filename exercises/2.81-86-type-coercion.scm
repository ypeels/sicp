(load "2.77-80-generic-arithmetic.scm")

; from ch2.scm
(define (apply-generic-2.81-86 op . args)
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
                  (cond ((eq? type1 type2)                                                  ; Exercise 2.81c: don't try coercion if arguments have the same type 
                         (error "No self-coercion for you!"))                               ; a better fix would prevent the unnecessary (get-coercion calls
                        (t1->t2                                                             ; but i don't feel like altering the indentation
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1                                                             ; this is a null check, NOT an invocation!!
                         (apply-generic op a1 (t2->t1 a2)))                                 ; wait, is this branch ever going to be called at all??
                        (else
                         (error "Coercion unavailable"; "No method for these types"         ; error message modified for Exercise 2.81
                                (list op type-tags))))))
              (coercion-n-args op args)
              ;(error "Coercion only implemented for 2-arg ops" ;"No method for these types" ; error message modified for Exercise 2.81
              ;       (list op type-tags))
          )))))
(define apply-generic apply-generic-2.81-86)  
   
(define (coercion-n-args op args)                                                           ; overridden in Exercise 2.82. Unlike 2.81, doesn't require a logic change!
    (error "Coercion only implemented for 2-arg ops" op args));(map type-tag args)))
                     

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

(define (install-sample-coercion)
    (define (scheme-number->complex n)
      (make-complex-from-real-imag (contents n) 0))      
    (put-coercion 'scheme-number 'complex scheme-number->complex) 
    "\nSample coercion installed: scheme-number -> complex"
)

                     
                     
(define (test-2.81-86)

    (display (install-sample-coercion))
    
    ;(newline) (display (scheme-number->complex (make-scheme-number 3.1)))
    (newline) (display ((get-coercion 'scheme-number 'complex) (make-scheme-number 3.1)))
)
; (test-2.81-86)