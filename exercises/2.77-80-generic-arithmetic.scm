(load "2.73-74-get-set-table.scm")

; from ch2.scm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;SECTION 2.4.2

(define (attach-tag-2.4.2 type-tag contents)
  (cons type-tag contents))

(define (type-tag-2.4.2 datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents-2.4.2 datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))
      
(define attach-tag attach-tag-2.4.2)
;(define type-tag type-tag-2.4.2)
;(define contents contents-2.4.2)

(define (type-tag datum)                                        ; Exercise 2.78; merged because Exercises 2.87- have enough headaches...
    (cond 
        ((number? datum)
            'scheme-number)
        ((pair? datum)
            (car datum))
        (else (error "Bad tagged datum -- TYPE-TAG" datum))))
(define (contents datum)
    (cond
        ((number? datum)
            datum)
        ((pair? datum)
            (cdr datum))
        (else (error "Bad tagged datum -- CONTENTS" datum))))
            
      
      
;;;SECTION 2.4.3

;; uses get/put (from 3.3.3) -- see ch2support.scm

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a) 
    (cons (* r (cos a)) (* r (sin a))))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y) 
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

;;footnote
;: (apply + (list 1 2 3 4))


(define (apply-generic-2.77-80 op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC-2.77-80"
            (list op type-tags))))))
(define apply-generic apply-generic-2.77-80)                ; added for exercises 2.81-86            


;; Generic selectors

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))


;; Constructors for complex numbers

(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rectangular) x y))

(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'polar) r a))
  

;;;SECTION 2.5.1

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

;(define (install-scheme-number-package)                                 ; generalized for Exercise 2.83 to allow 'integer and 'real
(define (install-scheme-number-package)
    (install-builtin-number-package 'scheme-number))
(define (install-builtin-number-package tag-value)
  (define (tag x)
    (attach-tag tag-value x))
  (put 'add (list tag-value tag-value)
       (lambda (x y) ((get 'make tag-value) (+ x y))))              ; modified from "(tag (+ x y)) for Exercises 2.87- (and thus retroactively for 2.78)                 
  (put 'sub (list tag-value tag-value)
       (lambda (x y) ((get 'make tag-value) (- x y))))
  (put 'mul (list tag-value tag-value)
       (lambda (x y) ((get 'make tag-value) (* x y))))
  (put 'div (list tag-value tag-value)
       (lambda (x y) ((get 'make tag-value) (/ x y))))
  (put 'equ? (list tag-value tag-value) =)                          ; added for Exercise 2.79
  (put '=zero? (list tag-value) (lambda (x) (= 0 x)))               ; added for Exercise 2.80
  (put 'make tag-value  
        ;(lambda (x) (tag x)))  
        (lambda (x)                                                 ; modified for Exercises 2.87- (and thus retroactively for 2.78)
            (if (eq? tag-value 'scheme-number)
                x
                (tag x))))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    ;(let ((g (gcd n d)))                                               ; "disabled" for Exercise 2.93    
    ;  (cons (/ n g) (/ d g))))                                         ; i mean, why break old code?
    (if (or (eq? 'polynomial (type-tag n)) (eq? 'polynomial (type-tag d)))
        (cons n d)
        (let ((g (gcd n d)))
            (cons (/ n g) (/ d g))
        )
    )
  )
    
  (define (add-rat x y)                                                 ; converted from + * = for Exercise 2.93
    (make-rat (add (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))
  (define (equ? x y)                                                    ; added for Exercise 2.79
    (and (equ? (numer x) (numer y)) (equ? (denom x) (denom y))))             
    
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'equ? '(rational rational) equ?)                                 ; added for Exercise 2.79. bool return (not a rat), so no tag
  (put '=zero? '(rational) (lambda (r) (equ? 0 (numer r))))             ; added for Exercise 2.80
  (put 'numer '(rational) numer)                                        ; numer and denom made public for Exercise 2.83
  (put 'denom '(rational) denom)                                        
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))
  (define (equ? z1 z2)                                                  ; added for Exercise 2.79
    (or                                                                 ; extravagantly cover rect-rect AND polar-polar equality...?
        (and (= (real-part z1) (real-part z2))                              ; probably shouldn't care about any floating point error...
            (= (imag-part z1) (imag-part z2)))
        (and (= (magnitude z1) (magnitude z2))
            (= (angle z1) (angle z2)))
    )
  )            

  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'equ? '(complex complex) equ?)                                   ; added for Exercise 2.79
  (put '=zero? '(complex) (lambda (z) (= 0 (magnitude z))))             ; added for Exercise 2.80
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(display "\nInstalling Scheme number package...") (display (install-scheme-number-package))
(display "\nInstalling rational number package...") (display (install-rational-package))
(display "\nInstalling complex number package...") (display (install-complex-package))
(display "\nInstalling rectangular complex repn...") (display (install-rectangular-package))
(display "\nInstalling polar complex repn...") (display (install-polar-package))
