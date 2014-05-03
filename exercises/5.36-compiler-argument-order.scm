; The order is right to left
; argl is built up using cons
    ; 5.5.3 p. 582: they choose to have the resulting argl match the source code's argument list order
    
; to modify this, you would override/rewrite construct-arglist p. 583 and its helper
    ; aha, you could just remove the "reverse" on p. 583. that's what makes things go right to left!
    ; i suppose if the (reverse) is expensive, efficiency would be improved.
        ; wait, that'd be COMPILE-TIME efficiency, since that's where the (reverse) is performed
            ; efficiency of the object code wouldn't be impacted at all...?
            ; not TOTALLY sure about that - and I don't feel like analyzing beyond Exercises 5.33-34
                ; those exercises seem kinda like special cases - 2 args, only 1 of which is a combination
            ; also, notice how easy it is to get confused between source and compiler languages
                ; the fact that this is a METACIRCULAR compiler doesn't help...
        ; meteorgan doesn't talk about efficiency at all: http://community.schemewiki.org/?sicp-ex-5.36
        ; wow, l0stman REALLY overthought things: https://github.com/l0stman/sicp/blob/master/5.36.tex


; the 5.4.1 reference is on p. 553? seems kinda pointless
    ; i guess their point is that you can actually find mechanistic code for order of evaluation?
        ; you don't have to figure things out empirically, like in chapter 1

        
(define (construct-arglist operand-codes)
  ;(let ((operand-codes (reverse operand-codes)))           ; <===== voila, some other order of evaluation.
    (if (null? operand-codes)
        (make-instruction-sequence '() '(argl)
         '((assign argl (const ()))))
        (let ((code-to-get-last-arg
               (append-instruction-sequences
                (car operand-codes)
                (make-instruction-sequence '(val) '(argl)
                 '((assign argl (op list) (reg val)))))))
          (if (null? (cdr operand-codes))
              code-to-get-last-arg
              (preserving '(env)
               code-to-get-last-arg
               (code-to-get-rest-args
                (cdr operand-codes)))))));)
                
                
    