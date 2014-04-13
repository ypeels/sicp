(display "\nType a complete expression (parenthesized if necessary) and press Enter: ")

; reads an EXPRESSION from user input.
; n.b. the metacircular evaluator can't implement I/O! that's "irreducibly primitive" in some sense
(define x (read))               


(display "\nYou typed\n") (display x)