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

(define louis (sqrt-stream-3.63 2.))
(define alyssa (sqrt-stream 2.))

(define iterations 2000)
(display "\nalyssa: ")(display (stream-ref alyssa iterations)) ; blazing fast, right? practically instantaneous
;(display "\nlouis: ") (display (stream-ref louis iterations))  ; noticeably slower - takes several seconds


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; frame analysis for alyssa / textbook (substitution model doesn't suffice? because memoized streams use STATE anyway!?

; Global frame G ----------------------------
; (sqrt-stream 2)
; evaluate in child frame A, child of G (where sqrt-stream lives)

; Frame A, child of G -----------------------
; x: 2 (argument)
; guesses: (1.0 . #promise (stream-map (lambda (guess (sqrt-improve guess x))) guesses))
; returns guesses. by 

; FEELS like louis is reevaluating the entire substream with every successive stream-cdr??
    ; if so, then his should scale quadratically
    ; that means alyssa at 4M should be just as slow - but who knows... "Out of memory!"

