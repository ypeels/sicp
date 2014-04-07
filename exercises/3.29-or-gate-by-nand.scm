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

; "What is the delay time of the or-gate in terms of and-gate-delay and inverter-delay?"
; if ONE of the input changes, you incur the sum of
    ; inverter-delay
    ; and-gate-delay
    ; inverter-delay
