(define (install-genesis)

    ; The following data base (see Genesis 4) traces the genealogy of the descendants of Ada back to Adam, 
    ; by way of Cain:    
    (query '(assert! (son Adam Cain)               ))
    (query '(assert! (son Cain Enoch)              ))
    (query '(assert! (son Enoch Irad)              ))
    (query '(assert! (son Irad Mehujael)           ))
    (query '(assert! (son Mehujael Methushael)     ))
    (query '(assert! (son Methushael Lamech)       ))    ; ok, so Lamech is a dude
    (query '(assert! (wife Lamech Ada)             ))    ; (wife ?man ?woman)
    (query '(assert! (son Ada Jabal)               ))
    (query '(assert! (son Ada Jubal)               ))
)

(define (install-genealogy)

    ; Formulate rules such as

    ; If S is the son of F, and F is the son of G, then S is the grandson of G
    (query '(assert! (rule (grandson ?G ?S) (and (son ?G ?F) (son ?F ?S))))) ; stupid parentheses
    
    ; If W is the wife of M, and S is the son of W, then S is the son of M - oh it's Man Woman
    (query '(assert! (rule (son ?Man ?Son) (and (wife ?Man ?Woman) (son ?Woman ?Son))))) ; ?Son and son shouldn't collide, right?
    
    ; apparently the "such as" rules are sufficient to enable the requested queries in (test-4.63).
    
    'genalogy-installed
)

(define (test-4.63)
    (load "ch4-query.scm")
    (init-query)
    (install-genesis)
    (install-genealogy)
    
    (query '(grandson Cain ?gs))
    ; (grandson cain ?s-1) ??? oh due to stupid parentheses error, which fails "silently"
    ; (grandson cain irad)
    
    (query '(son Lamech ?s))
    ; (son lamech jubal)
    ; (son lamech jabal). SOMEBODY wasn't very creative in naming their kids...
    
    (query '(grandson Methushael ?gs))
    ; (grandson methushael jubal)
    ; (grandson methushael jabal)
    
    
    (query-driver-loop)
)
;(test-4.63)
    