; this first version is from p. 109
(define (count-leaves tree)
  (cond ((null? tree) 0)
        ((not (pair? tree)) 1)
        (else (+ (count-leaves (car tree))
                 (count-leaves (cdr tree))))))
                 
                 
; just using built-in Scheme functions...
; not using their vector implementation, which was only given conceptually anyway
; hmm that just reduces this to an exercise in "assembly programming"...
; then again, we haven't or seen any assembly programs with data structures yet...
    ; in other words, our assembly programs have graduated to Chapter 2...
(define (make-count-machine-5.21a) (make-machine
    '(tree count continue temp)
    (list 
        (list 'null? null?)
        (list 'pair? pair?)
        (list '+ +)
        (list 'car car)                                 
        (list 'cdr cdr)
    )
    
    ; basic logic based on Fibonacci machine p. 512
    '(
        (assign continue (label count-done))
        
      ; (cond
      count-loop      
        ; ((null? tree) 0)
        (test (op null?) (reg tree))
        (branch (label immediate-answer-0))
      
        ; ((not (pair? tree)) 1)
        (test (op pair?) (reg tree))
        (branch (label count-tree))
        (goto (label immediate-answer-1))
        
      ; 2 recursive calls - follow p. 512.
      count-tree
        ;; set up to compute (count-leaves (car))
        (save continue)
        (save tree)
        (assign tree (op car) (reg tree))
        (assign continue (label aftercount-car))                
        (goto (label count-loop))   ; perform first recursive call
      
      
      aftercount-car                ; upon return, count contains count(car)
        (restore tree)
        (restore continue)
        
        ;; set up to compute (count-leaves (cdr))
        (save continue)             ; can be optimized out (as in Exercise 5.6)
        (save tree)                 ; CANNOT be optimized out, since the restored value of tree is USED
        (save count)
        (assign tree (op cdr) (reg tree))
        (assign continue (label aftercount-cdr))        
        (goto (label count-loop))   ; perform second recursive call  
      
      aftercount-cdr                ; upon return, count contains count(cdr)
        (assign temp (reg count))
        (restore count)
        (restore tree)              ; unnecessary? get rid of the matching push in aftercount-car?
        (restore continue)
        (assign count (op +) (reg count) (reg temp))
        (goto (reg continue))
      
      
      immediate-answer-0
        (assign count (const 0))
        (goto (reg continue))
      
      immediate-answer-1
        (assign count (const 1))
        (goto (reg continue))
      count-done
    )

))

                 
                 
; BUT i don't really feel like making any test data...
; oh (sols): if you're gonna use built-in primitives (car), (cdr), (pair?), (null?), just PASS IN a tree.

(define (test-5.21)
    (load "ch5-regsim.scm")
    
    (let (  (machine (make-count-machine-5.21a))
            (tree '(a (b c (d)) (e f) g)) ; meteorgan's test data
            )
        (set-register-contents! machine 'tree tree)
        (start machine)
        (display "\nRecursive simulation: ")
        (display (get-register-contents machine 'count))
        (display "\nScheme: ")
        (display (count-leaves tree))
    )
)
(test-5.21)
        