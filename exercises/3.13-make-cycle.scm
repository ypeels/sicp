; from problem statement
(define (make-cycle x)
  (set-cdr! (last-pair x) x)                ; changes (cdr (last-pair x)) from '() to x. does NOT "erase" last list item!
  x)

(display "\nhello world")
(display "\n(last-pair '(a b c)): ") (display (last-pair '(a b c))) ; (c)
(newline)
  
(define z (make-cycle (list 'a 'b 'c)))     ; (a b c a b c a b c ...)?
; (newline) (display z)                   ; will this not work? yep, infinite loop
(display (car z))
(display (cadr z))
(display (caddr z))                         ;
(display (cadddr z))                        ; abca

(display "\nEntering infinite loop...")
(last-pair z)                               ; infinite loop!
(display "\ngoodbye world")                 ; never executes