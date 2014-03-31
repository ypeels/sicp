; has nothing to do with MPI

; from problem statement
(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude)
           (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else
           (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
  dispatch)
(define (apply-generic op arg) (arg op))
; for NO good reason at all: "a data object is an entity that receives the requested operation name as a ``message.''"


; monkey see monkey poo
(define (make-from-mag-ang r a)
    (define (dispatch op)
        (cond 
            ((eq? op 'magnitude) r)
            ((eq? op 'angle) a)
            ((eq? op 'real-part)
                (* r (cos a)))
            ((eq? op 'imag-part)
                (* r (sin a)))
            (else
                (error "Unknown op -- MAKE-FROM-MAG-ANG" op))
        )
    )
    dispatch
)



(define (test-2.75)
    (define (test z)
        (display "\n\nRe(z) = ")    (display (apply-generic 'real-part z) )
        (display "\nIm(z) = ")      (display (apply-generic 'imag-part z) )
        (display "\n|z| = ")        (display (apply-generic 'magnitude z) )
        (display "\narg(z) = ")     (display (apply-generic 'angle z)     )
    )

    (test (make-from-real-imag 1 1))
    (test (make-from-mag-ang 1 (/ 3.1415926 2)))
)

; (test-2.75)

            