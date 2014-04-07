; by analogy with "half-adder"
; checked with http://community.schemewiki.org/?sicp-ex-3.29 instead of trying to set up a test environment
(define (or-gate a b output)
    (let ((~a (make-wire)) (~b (make-wire)) (nor-a-b (make-wire)))
        (inverter a ~a)
        (inverter b ~b)
        (and-gate ~a ~b nor-a-b)
        (inverter nor-a-b output)
        'ok
    )
)