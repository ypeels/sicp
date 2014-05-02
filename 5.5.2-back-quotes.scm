; isn't this a little late in the book to be introducing new language features??

; [This] feature of Lisp called backquote (or quasiquote) ... is handy for constructing lists.
; Preceding a list with a backquote symbol is much like quoting it, except that anything in the list that is flagged with a comma is evaluated.


(define (f x)
    `(x equals ,x))
    
(newline)
(display (f 1))
; (x equals 1)