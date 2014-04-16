; probably install a custom display function
; basically, just print the first N items
; MAYBE let the user select N (problem doesn't say "don't change existing behavior"!)
; MAYBE have (display L) call (display-n L (length L), and have users eat any errors they incur
; 
; they didn't even override "list", or even assign that to an exercise
; 
; but they DO have some example "streams" on p. 410 - just recursively-defined infinite lazy lists
; 
; if you ask me, this is just busywork - reimplement (print-n) from ch3support.scm
; 
; sols do something a little more elaborate to modify (user-print)
; well, i guess that's necessary, since otherwise just querying an infinite list will crash L-Eval...
; 
; 
; oh the problem DOES say "Modify the driver loop"
; 
; but yeah, sols BASICALLY just check if an object starts with 'cons, and if so, uses print-n.
; 
; there ARE some acrobatics involved in tweaking the global environment? meh

(load "4.32-34-lazy-cons-in-leval.scm")

(define user-print-mceval user-print)
(define (user-print obj)

    ; new helper function
    (define (printable-pair raw-output)
        ;(display "process output here: ")
        ;(display raw-output)
        ;raw-output
        "(...)"
    ) 

    (if (tagged-list? obj 'cons)
        (display (printable-pair obj))
        (user-print-mceval obj)
    )
)

; is there really no need to modify the driver loop itself??
;(define (driver-loop)
;
;
;
;
;  (prompt-for-input input-prompt)
;  (let ((input (read)))
;    (let ((output
;           ;(actual-value input the-global-environment)))           
;           (printable-output (actual-value input the-global-environment))))
;      (announce-output output-prompt)
;      (user-print output)))
;  (driver-loop))
;


(install-lazy-cons)

(leval
    '(cons 1 (cons 2 (cons 3 '()))) ; CURRENTLY INCOMPLETE.
)

; MEH, currently displays as (lambda (m)...)
; would have to alter the low-level representation as (cons 'pair (lambda (m)...)) or something
    ; hence the hint in the problem
    ; hence the acrobatics in the solution
