(define (test-4.45)

    (load "ch4-ambeval.scm")
    
    (load "4.35-37-require.scm")
    (install-require)
    
    (load "4.45-49-parsing-natural-language.scm")
    (install-natural-language-parser)
    
    (ambeval-batch '(define (t) (parse '(The professor lectures to the student in the class with the cat))))
    (driver-loop)
)
; (test-4.45)

; 1. (the professor) 
; (lectures 
;     (to the student) 
;     (in the class) 
;     (with the cat))
; 
; 2. (the professor)
; (lectures 
;     (to the student) 
;     (in the class (with the cat))))
; 
; 3. (the professor)
; (lectures 
;     (to the student (in the class))) 
;     (with the cat))
;     
; 4. (the professor)
; (lectures
;     (to the student 
;         (in the class)
;         (with the cat)))
;             
; 5. (the professor)
; (lectures
;     (to the student
;         (in the class
;             (with the cat))))
; 
; natural language does not (naturally) tell you which phrase modifies which.

; unambiguous
    ; subject = professor
    ; professor is always lecturing to the student
    
; ambiguous
    ; (in the class): the student or the lecturing?
    ; (with the cat): the class or the lecturing? or MAYBE even the student has the cat! (special case 4)
        ; notice that the grammar forbids "jumping" - can't have (lectures in the class) + (student with the cat) - that's a scrambled order.
        
; all in all pretty tedious and stupid
    ; it's a pretty ambiguous sentence to begin with.