; from ch2.scm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;SECTION 2.5.3

;;; ALL procedures in 2.5.3 except make-polynomial
;;; should be inserted in install-polynomial-package, as indicated

;; *incomplete* skeleton of package
(define (install-polynomial-package)
    (install-polynomial-package-2.89 'sparse))  ; '((order coeff))

(define (install-polynomial-package-2.89 package-term-type)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  
  ;;[procedures same-variable? and variable? from section 2.3.2]
    (define (variable? x) (symbol? x))

    (define (same-variable? v1 v2)
      (and (variable? v1) (variable? v2) (eq? v1 v2)))

  ;; representation of terms and term lists
  ;;[procedures adjoin-term ... coeff from text below]
    ;; Representing term lists
    
    (define (adjoin-term-original term term-list)                   ; renamed for Exercise 2.89
      (if (=zero? (coeff term))
        term-list
        (cons term term-list)))
    
    (define (the-empty-termlist) '())
    (define (first-term-original term-list) (car term-list))        ; renamed for Exercise 2.89
    (define (rest-terms term-list) (cdr term-list))
    (define (empty-termlist? term-list) (null? term-list))
    
    (define (make-term order coeff) (list order coeff))
    (define (order term) (car term))
    (define (coeff term) (cadr term))    
    

  ;;(define (add-poly p1 p2) ... )
    (define (add-poly p1 p2)
      (if (same-variable? (variable p1) (variable p2))
          (make-poly (variable p1)
                     (add-terms (term-list p1)
                                (term-list p2)))
          (error "Polys not in same var -- ADD-POLY"
                 (list p1 p2))))
  
  ;;[procedures used by add-poly]  
    (define (add-terms L1 L2)
      (cond ((empty-termlist? L1) L2)
            ((empty-termlist? L2) L1)
            (else
             (let ((t1 (first-term L1)) (t2 (first-term L2)))
               (cond ((> (order t1) (order t2))
                      (adjoin-term
                       t1 (add-terms (rest-terms L1) L2)))
                     ((< (order t1) (order t2))
                      (adjoin-term
                       t2 (add-terms L1 (rest-terms L2))))
                     (else
                      (adjoin-term
                       (make-term (order t1)
                                  (add (coeff t1) (coeff t2)))
                       (add-terms (rest-terms L1)
                                  (rest-terms L2)))))))))

                                  
  ;;(define (mul-poly p1 p2) ... )
    (define (mul-poly p1 p2)
      (if (same-variable? (variable p1) (variable p2))
          (make-poly (variable p1)
                     (mul-terms (term-list p1)
                                (term-list p2)))
          (error "Polys not in same var -- MUL-POLY"
                 (list p1 p2))))
  
  ;;[procedures used by mul-poly]
    (define (mul-terms L1 L2)
      (if (empty-termlist? L1)
          (the-empty-termlist)
          (add-terms (mul-term-by-all-terms (first-term L1) L2)
                     (mul-terms (rest-terms L1) L2))))

    (define (mul-term-by-all-terms t1 L)
      (if (empty-termlist? L)
          (the-empty-termlist)
          (let ((t2 (first-term L)))
            (adjoin-term
             (make-term (+ (order t1) (order t2))
                        (mul (coeff t1) (coeff t2)))
             (mul-term-by-all-terms t1 (rest-terms L))))))
       
      
      
  ;;Exercise 2.87 - required to get (adjoin-term, and thus (add and (mul working
    ; needs access to private member functions like (term-list
    (define (=zero-poly? p) ; do NOT name it =zero?, because that GENERIC function is called INTERNALLY
        (define (iter terms)
            (cond
                ((empty-termlist? terms)
                    true)                               ; scanned all terms without finding a nonzero coeff.                    
                ((not (= 0 (coeff (first-term terms))))
                    false)
                (else 
                    (iter (rest-terms terms)))
            )
        )
        
        (iter (term-list p))
    )
    
  ;;Exercise 2.88: sub-poly by simply negating and adding.
    ; could ALMOST define this externally, but need the private accessor (variable...
    ;(define (sub-poly p1 p2)
    ;    (add-poly p1 (negate p2)))        
    ;(define (negate p)
    ;    (mul-poly                       ; meh. this probably won't work for coeffs that are polynomials, without coercion...
    ;        p
    ;        (make-poly (variable p) '((0 -1)))
    ;    )
    ;)
    
    ; refactored for Exercise 2.91. added error checking instead of relying on (add-poly's, just so i can have a usable (sub-terms
    (define (sub-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly 
                (variable p1)
                (sub-terms
                    (term-list p1)
                    (term-list p2)
                )
            )
            (error "Polys not in same var -- SUB-POLY" (list p1 p2))
        )
    )
    (define (sub-terms L1 L2)
        (add-terms L1 (negate-terms L2)))
    
    ; by analogy with (mul-term-by-all-terms
    (define (negate-terms term-list)        
        (if (empty-termlist? term-list)
            (the-empty-termlist)
            (let ((t (first-term term-list)))
                (adjoin-term
                    (make-term (order t) (mul -1 (coeff t)))
                    (negate-terms (rest-terms term-list))
                )
            )
        )
    )
        
            
  ;; Exercise 2.89 - "dense" polynomial term representation, via quick backwards-compatible changes
    (define (adjoin-term term term-list)
        (cond 
            ((not (eq? 'dense package-term-type))               ; backwards compatibility
                (adjoin-term-original term term-list))      
            ((=zero? (coeff term))                              ; works because ONLY (first-term blah) gets passed to (adjoin-term)!!
                term-list)
            ((> (order term) (length term-list))                ; need a zero coefficient
                (adjoin-term term (cons 0 term-list)))
            ((< (order term) (length term-list))
                (error "Hmm, i thought adjoin-term was only supposed to be called on a growing list" term term-list))
            (else
                (cons (coeff term) term-list))
        )
    )
    (define (first-term term-list)
        (if (not (eq? 'dense package-term-type))                ; backwards compatibility
            (first-term-original term-list)
            (make-term (car term-list) (- (length term-list) 1))
        )
    )
        ; ohhhhh (from sols): you can KEEP (order and (coeff  (and you probably MUST, unless you want to rewrite (add-terms )
            ; and you can even keep (make-term, as long as (adjoin-term stores the result in a DENSE LIST.
            ; all you have to do is HACK FIRST-TERM! clever clever Schemers...
       
       
  ;;Exercise 2.91: div-poly 
    ; from problem statement
    (define (div-terms L1 L2)
      (if (empty-termlist? L1)
          (list (the-empty-termlist) (the-empty-termlist))
          (let ((t1 (first-term L1))
                (t2 (first-term L2)))
            (if (> (order t2) (order t1))
                (list (the-empty-termlist) L1)
                (let ((new-c (div (coeff t1) (coeff t2)))       ; divide the highest-order term of the dividend by the highest-order term of the divisor. 
                      (new-o (- (order t1) (order t2))))        ; The result is the first term of the quotient.
                  (let ((rest-of-result
                  
                  
                         ;<compute rest of result recursively>
                         ; multiply the result by the divisor, subtract that from the dividend, 
                         ; and produce the rest of the answer by recursively dividing the difference by the divisor.                         
                         (div-terms
                             (sub-terms 
                                 L1                                          ; the dividend (L1 / L2 = dividend / divisor)
                                 (mul-terms 
                                     (adjoin-term 
                                         (make-term new-o new-c)             ; "the result" of dividing L1 by the highest term of L2
                                         (the-empty-termlist)
                                     )
                                     L2                                      ; the divisor
                                 )
                             )
                             L2
                         )
                         
                         )) ; let rest of result
                    
                    ;<form complete result>
                    ;(cons
                    ;    (add-terms
                    
                    
                    ))))))
  
           
       
       
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial) 
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial) 
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put '=zero? '(polynomial) =zero-poly?)                           ; Exercise 2.87
  (put 'sub '(polynomial polynomial)                                ; Exercise 2.88
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  'done)


;; Constructor
(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))
  
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "2.77-80-generic-arithmetic.scm")
(load "2.80-equals-zero.scm")               ; required to get (add and (mul to work even with NUMBER coeffs
;(load "2.78-obsoleting-scheme-number.scm")
(display "\nInstalling polynomial package...")(display (install-polynomial-package))
  
; first try some testing code
(define (test-2.87-91)
    
    (define (test p1 p2)
        (newline)
        (newline) (display p1) (display p2)
        (display "\nadd: ") (display (add p1 p2))
        (display "\nmul: ") (display (mul p1 p2))
    )
    
    (let (  (p (make-polynomial 'x '((1 1) (0 -1))))
            (zero (make-polynomial 'x '((1 0) (0 0))))
            )
        (test p p)
        (cond 
            ((=zero? zero)
                (display "\nZero polynomial checks fine!")
                'unused-return-value)
            (else
                (error "=zero? test failed" zero))
        )
    )
)
; (test-2.87-91)
    
; then move on to exercises