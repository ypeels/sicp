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




      
      
(define (test-5.22)
    (load "ch5-regsim.scm")

    (let (  (machine (make-append-machine))
            (machine! (make-append!-machine))
            (a '(1 2 3))
            (b '(4 5 6 7))
            )
        
        (set-register-contents! machine 'list1 a)
        (set-register-contents! machine 'list2 b)
        (start machine)
        (display "(append a b) = ") 
        (display (get-register-contents machine 'retval))
        (newline)
        (display "with a = ")
        (display (get-register-contents machine 'list1))
        (newline)
        (newline)
    )
)
(test-5.22)