; not in ch3.scm!?
(define (average x y)
    (/ (+ x y) 2))

; from ch3.scm
(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

;;;SECTION 3.5.3

(define (sqrt-improve guess x)
  (average guess (/ x guess)))


(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

;: (display-stream (sqrt-stream 2))



; try it out - louis reasoner's version from problem statement
(define (sqrt-stream-3.63 x)
  (cons-stream 1.0
               (stream-map (lambda (guess)
                             (sqrt-improve guess x))
                           (sqrt-stream-3.63 x))))
; and i THINK this'll be cleared up by working out the environment diagram (frames!!!)

(define (test-3.63)
    (define louis (sqrt-stream-3.63 2.))
    (define alyssa (sqrt-stream 2.))

    (define iterations 2000)
    (display "\nalyssa: ")(display (stream-ref alyssa iterations)) ; blazing fast, right? practically instantaneous
    (display "\nlouis: ") (display (stream-ref louis iterations))  ; noticeably slower - takes several seconds
)
;(test-3.63)

; FEELS like louis is reevaluating the entire substream with every successive stream-cdr??
    ; if so, then his should scale quadratically
    ; that means alyssa at 4M should be just as slow - but who knows... "Out of memory!"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; frame analysis for alyssa / textbook (substitution model doesn't suffice? because memoized streams use STATE anyway!?

; Global frame G ----------------------------
; (sqrt-stream 2)
; evaluate in new frame A, child of G (where sqrt-stream lives)

; Frame A, child of G -----------------------
; x: 2 (argument)
; guesses: (1.0 . #promise (stream-map (lambda (guess) (sqrt-improve guess x)) guesses))
; returns guesses, by POINTER, because it is a pair.
    ; thus, any (stream-ref) applications to (sqrt-stream) will evaluate on the SAME DATA STRUCTURE, guesses
    ; results will be memoized by stream-cdr / force.

    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; frame analysis for louis?
; (define louis (sqrt-stream-3.63 2))
; evaluate in new frame L, child of G (where sqrt-stream-3.63 lives)

; Frame L, child of G ----------------------------
; x: 2 (argument)
; return ( 1.0 . #promise (stream-map (lambda (guess) (sqrt-improve guess x)) (sqrt-stream-3.63 x)))


; ok, so....
; (stream-ref louis 0)
    ; (stream-car (1.0 . #promise ... ))
    ; just returns 1.0, nice and easy.
; (stream-ref louis 1)
    ; (stream-car (stream-map (lambda (guess) (sqrt-improve guess x)) (sqrt-stream-3.63 x)))
        ; re-evaluates (sqrt-stream-3.63 x)
        ; applies the lambda to its first term
        ; returns that improved guess
        ; not really any extra cost, but notice that sqrt-stream DID get called again, instead of simple memoized lookup.
; (stream-ref louis 2)
    ; fresh call to (sqrt-stream-3.63), which lives in G, because it's a FRESHLY CONSTRUCTED STREAM (call to (cons-stream) in new frame)
    ; re-evaluates (stream-ref louis 1) - streams in (recalculates) the first term because it's a fresh new stream
    ; but need to return the SECOND term of (stream-map (lambda (guess) (sqrt-improve guess x)) (sqrt-stream-3.63 x))
        ; that will trigger ANOTHER calculation of (stream-ref louis 1), and use that as the input to the lambda
    ; in general, a triangular number of evaluations of the lambda, instead of just linear.
        ; i think?
        
; without memoization, it looks like the textbook's method would do the same thing (keep refulfilling promise to reevaluate)
    ; but with more overhead!
    

    
; louis, take 2 - substitution model
; "(define (improve stream) (stream-map (lambda (guess) (sqrt-improve guess x)) stream))"
; (stream-ref louis 0)
    ; (1) - #promises not shown
; (stream-ref louis 1)
    ; (1 (improve 1))
; (stream-ref louis 2)
    ; (1 (improve 1 (improve 1)))
    ; (1 (improve 1 i1)) - using shorthand ik == (improve) applied to 1, k-times
    ; (1 i1 i2) - it's improving the entire sublist again and again
    ; returns i2
; (stream-ref louis 3)
    ; (1 (improve 1 (improve 1 (improve 1))))
    ; (1 (improve 1 (improve 1 i1)))
    ; (1 (improve 1 i1 i2))
    ; (1 i1 i2 i3)
    ; returns i3
    ; so there's your triangular number of evaluations
    

        
    
    


