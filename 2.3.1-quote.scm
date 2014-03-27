; whoa wtf is this stuff
; introducing several new non-intuitive language features.
(define a 1)

; Introducing Quotations. (They're not really well defined in the text...)
; => a
; 1
; => "a"
; "a"
; => 'a  ; note NO CLOSING QUOTATION MARK. fucking bizarre...
; a      ; which is NEITHER the value nor a string. it's a "symbol"...
; => 'b
; b      ; symbol doesn't need to be have a value


(newline) (display 'a)                                              ; a


; Rule 1: '<expr> is equivalent to (quote <expr>)
; quote is built-in. But why is it necessarily a "special form"?
(newline) (display "Rule 1: ") (display (eq? 'aaa (quote aaa)))     ; #t
    ; another new built-in: (eq?)
    ; "takes two symbols as arguments and tests whether they are the same...
    ; We can consider two symbols to be ``the same'' if they consist of the same characters in the same order."
                                                     

; Rule 2a: 'a returns the SYMBOL a
    ; not totally sure what that means... but (display 'a) outputs the literal character "a", and not its value
; Rule 2b: '123 returns the NUMBER 123. similarly #t and #f
    ; MAYBE this resolves the puzzle about nil? it could be a VALUE, and therefore immune to "symbolization"?


; Rule 3: '(a b c) is equivalent to (list 'a 'b 'c). 
    ; PARENTHESES CHANGE THE BEHAVIOR of the single quotation mark.
    ; an historical form?
    ; (eq?) does NOT work between lists, but only its elements
(newline) (display "Rule 3: ") (display (eq? (car '(a b c)) 'a))    ; #t
; maybe (quote) is considered a special form because it does different things depending on the first character?
    ; no, you could conceive of a function that simply checked the first character before acting...
; "Quotation also allows us to type in compound objects, using the conventional printed representation for lists:"



; p. 144: "In keeping with this, we can obtain the empty list by evaluating '(), and thus dispense with the variable nil."
; this was hinted at on p. 101 footnote 10.
; but wtf is '()??!?!? 
    ; Is it the SYMBOL ()??
    ; Is it a LIST containing nothing?? (it's probably this)
        ; By Rule 3, '() is (list)
    ; Is there a difference? Especially in practice
(newline) (display "Nil... ") (display (eq? () '()))                ; #t        
    


; Finally, the built-in memq, which can be considered as having the following definition from p. 144
;(define (memq item x)
;  (cond ((null? x) false)
;        ((eq? item (car x)) x)
;        (else (memq item (cdr x)))))  
(newline) (display "memq 1: ") 
(display (memq 'apple '(pear banana prune)))                        ; #f
(newline) (display "memq 2: ") 
(display (memq 'apple '(x (apple sauce) y apple pear)))             ; (apple pear)
    ; '(x (apple sauce) y apple pear)   - apply Rule 3.
    ; = ('x '(apple sauce) 'y 'apple 'pear)
    ; = ('x ('apple 'sauce) 'y 'apple 'pear)
    ; memq does NOT go into nested lists, so it scans all the way to ('apple 'pear)




; Remarks
    ; Quotation leads naturally to self-reference, and all the issues of Godel/Escher/Bach.
    ; Maybe that's why Lisp is so firmly entrenched in the AI community? 
        ; Because you can make meta-linguistic statements naturally and concisely?
    ; Also, if you're going to do meta-linguistic manipulations, you probably want your original language to be SIMPLE
        ; hence scheme's minimalism?