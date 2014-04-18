; evaluator modifications kept in a single file to minimize load order dependencies...
(load "4.51-53-permanent-set-and-if-fail.scm")

(define (test-4.51)

    (load "4.35-37-require.scm")
    (install-require) ; needed for (an-element-of)

    (ambeval-batch
    
        ; wow, really haven't needed before!?
        '(define (an-element-of items)
          (require (not (null? items)))
          (amb (car items) (an-element-of (cdr items))))

        
        ; from problem statement (wrapped the "let" in a function for easy calling)
        '(define count 0)
        '(define (t1)
            (let ((x (an-element-of '(a b c)))
                  (y (an-element-of '(a b c))))
              (permanent-set! count (+ count 1))
              (require (not (eq? x y)))
              (list x y count))
        )
        
        ; modified from problem statement
        '(define (t2)
            (let ((x (an-element-of '(a b c)))
                  (y (an-element-of '(a b c))))
              (set! count (+ count 1))
              (require (not (eq? x y)))
              (list x y count))
        )
    )
    (driver-loop)
)
(define analyze analyze-4.51) (test-4.51)
; (t1) - permanent-set!
; a b 2 - because BACKTRACKING killed (a.a), but not its count++.
; a c 3
; b a 4
; b c 6 - similarly, backtracking killed (b.b)
; c a 7
; c b 8
; no more values (but count = 9 now!)

; (t2) - set!
; a b 1
; a c 1
; b a 1
; b c 1
; c a 1
; c b 1
; backtracking always brings count back to 0 before trying a new branch.
