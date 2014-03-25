; from problem statement
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        ;(append rest (map <??> s)))))   
        ;(append rest (map (<??> rest s) s)))))  ; back-building the result "iteratively"
        
        (append 
            rest                    ; results from completed recursion
            (map
                ;<??>
                s
            )
        ))))
                
                
                ;(<??> s rest) ; wow that IS some flexible syntax... but let's not bother making it TOO complicated
                ;(lambda (s) (subsets s))
                
                
                ; ok, so the (map) means that you're doing something with the INDIVIDUAL members of s
        
                
                
; my contributions
(define nil ())
;(define <??> ; wow that IS some flexible syntax...
;    
;    ; nope, returns (() 3 2 3 1 2 3)
;    ;(lambda (s) s)
;    
;    ; nope, (() (3) (2) (3) (1) (2) (3))
;    (lambda (s) (list s))
;        ; does this mean that i need to pass "rest" as an argument too?
;)

(define (<??> rest s)
    (display "\n\nrest: ") (display rest)
    (display "\ns: ") (display s)
    (lambda (item)
        (display "\nitem: ") (display item)
        ;(list item)
        
        ;(map (lambda (set) (append (list item) set)) rest)
        (list item)
        
        ; maybe map something onto rest?
    )
)




(define (test-2.32)
    (newline)
    (display "(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)) - expected answer\n")
    (display (subsets (list 1 2 3)))
)

(test-2.32)



    