; it took them a HUNDRED PAGES to introduce lists, the foundation of LISt Processing languages...

; "In general, (list <a1> <a2> ... <an>)
; is equivalent to (cons <a1> (cons <a2> (cons ... (cons <an> nil) ...)))"

(define one-through-four (list 1 2 3 4))
(newline) (display one-through-four)  ; (1 2 3 4)

; "Be careful not to confuse the expression (list 1 2 3 4) with [its value] (1 2 3 4)"
    ; Wouldn't it have been easier to define the value with a DIFFERENT BRACKET, like (list 1 2 3 4) = [1 2 3 4]!?!?

    
(newline) (display (car one-through-four))  ; 1
(newline) (display (cdr one-through-four))  ; (2 3 4)

; omfg... "Since nested applications of car and cdr are cumbersome to write, Lisp dialects provide abbreviations for them...
;   ; The names of all such procedures start with c and end with r."
;   ; actually, this list is FINITE. just check out the syntax highlighting!
    ; i bet, i BET this is a holdover from 6-letter assembler operators
;   0   NOT cr
;   1   car 
;       cdr
;   2   caar 
;       cadr cdar 
;       cddr
;   3   caaar
;       caadr cadar cdaar 
;       caddr cdadr cddar 
;       cdddr
;   4   caaaar 
;       caaadr caadar cadaar cdaaar 
;       caaddr cadadr caddar cdaadr cdadar cddaar
;       cadddr cdaddr cddadr cdddar
;       cddddr
;   5   NOT caaaaar 
    
(newline) (display (cadr one-through-four)) ; 2
(newline) (display (caddr one-through-four)) ; 3
(newline) (display (cadddr one-through-four)) ; 4
(newline) (display (cddddr one-through-four)) ; (), the "end-of-list marker".


; List operations: introducing
    ; (): the built-in nil item/end-of-list marker/empty list
    ; (null?), which tests for the empty list
    ; (list-ref), the built-in list-indexing procedure
    ; (length)

; (newline) (display (= () (cddddr one-through-four))) ; no, "=" only works for numbers...?
(newline) (display (null? ()))                          ; #t
(newline) (display (null? (cddddr one-through-four)))   ; #t
(newline) (display (list-ref one-through-four 2))       ; 3 (yes, scheme uses zero-indexing!)
;(newline) (display (list-ref one-through-four -1))      ; not an index integer
;(newline) (display (list-ref one-through-four 0.1))     ; not an index integer
;(newline) (display (list-ref one-through-four "a"))     ; not an index integer
;(newline) (display (list-ref one-through-four 4))       ; not in the correct range. (yes, mit scheme has range-checking!!)
(newline) (display (length one-through-four))           ; 4

(define L (list 5 6 7 8 9))
(newline) (display (append one-through-four L))         ; (1 2 3 4 5 6 7 8 9) - p. 103: "cdr up" first arg from end (recursively, of course), and "cons onto" second arg