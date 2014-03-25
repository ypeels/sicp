(define nil ())

; everything here is from problem statement except what is boxed off
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map 
            
            ; <??>
            ; --------------------------------------------------------------
            ;(lambda (item) (append (list (car s)) rest)) ; not QUITE...
            (lambda (item) (cons (car s) item))
            ; --------------------------------------------------------------
            ; takes (car s), the only item which hasn't been merged in yet
            ; and prefixes it onto every subset in the current result list (rest)
            ; - the enclosing append merges all the results.
            
            
            rest)))))        ; dammit, i had this as (map <??> s) for a WHILE...
;;;;;;;;;;;;;;;;;;;        
                
                







(define (test-2.32)
    (newline)
    (display "(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)) - expected answer\n")
    (display (subsets (list 1 2 3)))
)

; (test-2.32)



    