; actual code moved here to facilitate reuse in 5.17.
(load "5.15-17-instruction-counting-and-tracing.scm")

; only retaining the test code below...

(load "ch5-regsim.scm")
(load "5.06-fibonacci-extra-push-pop.scm")
;(define make-new-machine-regsim make-new-machine) (define make-new-machine make-new-machine-5.15)
(define make-new-machine (make-make-new-machine-5.15 make-new-machine)) ; relies on NON-lazy evaluation!!

; regression test
(test-5.6-long)

(define fib-machine (make-fib-machine-5.6))

(define (test n)
    (display "\n\nFib of ")
    (display n)
    (set-register-contents! fib-machine 'n n)
    (start fib-machine)
    (fib-machine 'print-instruction-count)
)

(test 0)    ; 5
(test 1)    ; 5
(test 2)    ; 26
(test 3)    ; 47
(test 4)    ; 89
 