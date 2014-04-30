; from ch2.scm
;(define (append list1 list2)
;  (if (null? list1)
;      list2
;      (cons (car list1) (append (cdr list1) list2))))
      
      
(define (make-append-machine) (make-machine
    '(list1 list2 retval temp continue)
    (list 
        (list 'null? null?)
        (list 'cons cons)
        (list 'car car)
        (list 'cdr cdr)
    )
    
    ; the flow of control should be basically the same as factorial
    '(
        (assign continue (label append-done))
      append-loop
      
        ; (if (null? list1)
        (test (op null?) (reg list1))
        (branch (label base-case))
        
        ; set up for the recursive call
        (save continue)
        (save list1)
        (assign list1 (op cdr) (reg list1))
        (assign continue (label after-append))
        (goto (label append-loop))
        
      after-append                          ; retval contains (append (cdr list1) list2)
        (restore list1)
        (restore continue)
        (assign temp (op car) (reg list1))
        (assign retval (op cons) (reg temp) (reg retval))
        (goto (reg continue))        
        
      base-case
        (assign retval (reg list2))
        (goto (reg continue))
        
      append-done
    )
))
      
      
      
;; from Exercise 3.12
;(define (append! x y)
;  (set-cdr! (last-pair x) y)
;  x)
;
;(define (last-pair x)
;  (if (null? (cdr x))
;      x
;      (last-pair (cdr x))))



; assumes list1 is non-empty.
    ; you could make a more robust version by also checking whether x is null, and if so, just set it to y
(define (make-append!-machine) (make-machine
    '(list1 list2 retval continue) ;temp)
    (list 
        (list 'null? null?)
        (list 'cdr cdr)
        (list 'set-cdr! set-cdr!)
    )
    
    ; the flow of control is a little easier
        ; just cdr down list1 until you get to the end
        ; then use set-cdr! to chain the lists together
    '(
        (assign continue (label append!-done))
        (assign retval (reg list1))
        (save list1)    ; for matching pop at end of program
        
      append!-loop      
        ; (if (null? (cdr x))
        ;(assign temp (op cdr) (reg list1))  ; is there a way to avoid using a trash register here??        
        ;(test (op null?) (reg temp))
        (save list1)
        (assign list1 (op cdr) (reg list1))
        (test (op null?) (reg list1))
        (restore list1) ; ohhh just exploit the fact that only (test) and (branch) affect the flag register
        (branch (label glue-lists!))
        
        ; (last-pair (cdr x))))
        (assign list1 (op cdr) (reg list1))
        (goto (label append!-loop))
        
      glue-lists!
        (perform (op set-cdr!) (reg list1) (reg list2))    
    
      append!-done
        (restore list1) ; not really needed per se, but used to check that (append!) does destroy list1.
    )
))
      
      
(define (test-5.22)
    (load "ch5-regsim.scm")
    
    (define (test machine title)
        (let (  (list1 '(1 2 3))
                (list2 '(4 5 6 7))
                )
            (set-register-contents! machine 'list1 list1)
            (set-register-contents! machine 'list2 list2)
            (start machine)
            (display title)
            (display "(list1 list2) = ") 
            (display (get-register-contents machine 'retval))
            (newline)
            (display "with list1 = ")
            (display (get-register-contents machine 'list1))
            (newline)
            (newline)
        )
    )

    (let (  (m (make-append-machine))
            (m! (make-append!-machine))
            )
        (test m "append")
        (test m! "append!")
    )
)
(test-5.22)