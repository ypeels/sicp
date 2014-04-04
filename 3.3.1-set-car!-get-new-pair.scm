(define p (cons 1 2))
(set-car! p 3)                  ; similarly set-cdr!
(newline) (display p) ; (3 . 2)

; Footnote 18: "Get-new-pair is one of the operations that must be implemented as part of the memory 
;   management required by a Lisp implementation."
;(get-new-pair)  ; Unbound variable: get-new-pair



; and now some more notes from the subsection "Sharing and identity"
(define x (list 'a 'b))
(define z1 (cons x x))                                      ; cons puts POINTERS in a pair.
(define z2 (cons (list 'a 'b) (list 'a 'b)))
(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)

(define (check)
    (newline)
    (display "\nz1 = ") (display z1)
    (display "\nz2 = ") (display z2)
    (display "\nz1 eq? z2: ") (display (eq? z1 z2))         ; eq? checks for POINTER equality
    (display "\nz1 equal? z2: ") (display (equal? z1 z2))   ; equal? checks for VALUE equality
    (display "\n(car z1) eq? (cdr z1): ") (display (eq? (car z1) (cdr z1)))
    (display "\n(car z1) equal? (cdr z1): ") (display (equal? (car z1) (cdr z1)))
    (display "\n(car z2) eq? (cdr z2): ") (display (eq? (car z2) (cdr z2)))
    (display "\n(car z2) equal? (cdr z2): ") (display (equal? (car z2) (cdr z2)))
)

(check)
; z1 = ((a b) a b)
; z2 = ((a b) a b)
; z1 eq? z2: #f
; z1 equal? z2: #t
; car vs cdr, z1: eq? and equal? both #t
; car vs cdr, z2: eq? #f, equal? #t


(set-to-wow! z1)
(set-to-wow! z2)
(check)
; z1 = ((wow b) wow b)
; z2 = ((wow b) a b)                    ; Footnote 19: The two pairs are distinct because each call to cons returns a new pair.
; z1 eq? z2: #f
; z1 equal? z2: #f of course
; car vs cdr, z1: eq? and equal? both #t
; car vs cdr, z2: eq? and equal? both #f