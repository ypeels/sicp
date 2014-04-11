; modifying (list-of-values) slightly
(define (list-of-values-left-to-right exps env)
  (if (no-operands? exps)
      '()
      (let ((first-value (eval (first-operand exps) env))) 
        
          (cons 
                first-value
                (list-of-values (rest-operands exps) env)))))
            
(define (list-of-values-right-to-left exps env)
  (if (no-operands? exps)
      '()
      (let ((rest-of-values (list-of-values (rest-operands exps) env)))
          (cons (eval (first-operand exps) env)
                rest-of-values))))
                

; not QUITE sure how to test these... meh just compare with sols
; one sol mentions "let*", but that's not introduced until Exercise 4.7, so bleh. i got the basic method right.
