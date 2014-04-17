(define (install-multiple-dwelling-4.39)
    (ambeval-batch
    
        '(define (multiple-dwelling)
          (let ((baker (amb 1 2 3 4 5))
                (cooper (amb 1 2 3 4 5))
                (fletcher (amb 1 2 3 4 5))
                (miller (amb 1 2 3 4 5))
                (smith (amb 1 2 3 4 5)))
                
            ; "super" requirements - the most restrictive possible!
            ; i BET this doesn't really speed up the program anyway.
            (require (= baker 3))
            (require (= cooper 2))
            (require (= fletcher 4))
            (require (= miller 5))
            (require (= smith 1))
                
            (require
             (distinct? (list baker cooper fletcher miller smith)))
            (require (not (= baker 5)))
            (require (not (= cooper 1)))
            (require (not (= fletcher 5)))
            (require (not (= fletcher 1)))
            (require (> miller cooper))
            (require (not (= (abs (- smith fletcher)) 1)))  
            (require (not (= (abs (- fletcher cooper)) 1)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))
    
        '(define m multiple-dwelling)
    )
)

(define (test-4.39)

    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    (load "4.38-44-distinct.scm")
    (install-distinct)

    (install-multiple-dwelling-4.39)
    (ambeval-batch '(define m multiple-dwelling))
    
    (driver-loop)
)
;(test-4.39)

; wait, ordering the (require)s only saves you the slight extra overhead of computing extra (require)s.
; if you reorder statements so that the most restrictive requirements come first, 
    ; the ONLY savings is not having to run the subsequent (require)s anymore.
    
; i BET the method is NEARLY just as slow, even with the "super-requirement" (3, 2, 4, 5, 1)

; reordering would only really come into play if there were only a few cases but thousands of requires.

; http://community.schemewiki.org/?sicp-ex-4.39
; sols beg to differ - saying that (distinct?) is slow (quadratic) and should be saved for last.
; meh not gonna bother testing this...
