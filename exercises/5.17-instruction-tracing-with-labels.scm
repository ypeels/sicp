(load "5.15-17-instruction-counting-and-tracing.scm")



(load "ch5-regsim.scm")
(load "5.06-fibonacci-extra-push-pop.scm")

; overrides
(define make-new-machine (make-make-new-machine-5.15 make-new-machine))
(define make-new-machine (make-make-new-machine-5.16 make-new-machine))

(define make-execution-procedure (make-make-execution-procedure-5.16 make-execution-procedure))
(define make-execution-procedure (make-make-execution-procedure-5.17 make-execution-procedure))


; regression test
(load "5.06-fibonacci-extra-push-pop.scm")
(test-5.6-long)


(test-5.16)
; TODO: check that multiple labels get printed
; TODO: double-check instruction counting ain't broken