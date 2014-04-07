; analogous to "and-gate" from ch3.scm.
; checked with http://community.schemewiki.org/?sicp-ex-3.28 instead of trying to set up a test environment
(define (or-gate o1 o2 output)
  (define (or-action-procedure)
    (let ((new-value
           (logical-or (get-signal o1) (get-signal o2))))
      (after-delay or-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! o1 or-action-procedure)
  (add-action! o2 or-action-procedure)
  'ok)
  
; analogous to "logical-and" from ch3support.scm
(define (logical-or x y)
  (if (or (= x 1) (= y 1))
      1
      0))
