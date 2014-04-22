(load "ch4-query.scm")

; modified as per problem statement
(define (add-assertion-4.70! assertion)                 
  (store-assertion-in-index assertion)             
  ;(let ((old-assertions THE-ASSERTIONS))
  ;  (set! THE-ASSERTIONS                           
  ;        (cons-stream assertion old-assertions))  
  ;  'ok))                                          
  (set! THE-ASSERTIONS (cons-stream assertion THE-ASSERTIONS)))
    ; ahh the (let) is required because (cons-stream) leaves 2nd argument unevaluated.
        ; the stream-cdr will point back to THE-ASSERTIONS at the TIME OF (forced) EVALUATION
    
    ; remember, kids: delayed evaluation and assignment do NOT mix well!
        ; Exercises 3.51-52 and footnote 59, p. 325
        ; Exercises 4.27, 29
        ; Chapter 4 Footnote 36    
  
    ; oh another thing is that due to indexing, you won't see the infinite loop until a NON-INDEXED query
  
(define add-assertion! add-assertion-4.70!)
(init-query) ; infinite loop? no, only upon LOOKUP

(query '(assert! ((great grandson) Lupin1 Lupin4)))
(query '(assert! ((great grandson) Lupin2 Lupin5)))
(query '((great grandson) ?ggf ?ggs))
    ; infinite loop on most recently added assertion.

(display "never gets here")
(query-driver-loop)



