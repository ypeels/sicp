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




; this one is going to be trickier, because i can't just copy fib's logic...

; i don't think this version was in the book previously
; it's just a minor variation...
(define (count-leaves-explicit tree)
  (define (count-iter tree n)
    (cond ((null? tree) n)
          ((not (pair? tree)) (+ n 1))
          (else (count-iter (cdr tree)
                            (count-iter (car tree) n)))))
  (count-iter tree 0))

(define (make-count-machine-5.21b) (make-machine
    '(tree n continue retval) ; the extra register "regval" is probably a luxury...
    (list 
        (list 'null? null?)
        (list 'pair? pair?)
        (list '+ +)
        (list 'cdr cdr)
        (list 'car car)
    )
    '(
        (assign continue (label count-done))
        
        ; (count-iter tree 0)
        (assign n (const 0))
      count-loop
        ; ((null? tree) n)
        (test (op null?) (reg tree))
        (branch (label return-n))
        
        ; ((not (pair? tree)) (+ n 1))
        (test (op pair?) (reg tree))
        (branch (label recurse))
        (goto (label return-n+1))
        
      recurse        
        ; (count-iter (car tree n))
        (save tree)
        (save continue)
        (assign tree (op car) (reg tree))
        (assign continue (label afteriter-car))
        (goto (label count-loop))
        
        
      afteriter-car         ; upon return, retval contains (count-iter (car tree) n)
        (restore continue)
        (restore tree)
        
        ; (count-iter (cdr tree) retval)
        ;(save tree)
        ;(save continue)
        (assign tree (op cdr) (reg tree))
        (assign n (reg retval))
        (goto (label count-loop))
        
      return-n
        (assign retval (reg n))
        (goto (reg continue))
      return-n+1
        (assign retval (op +) (reg n) (const 1))
        (goto (reg continue))
        
      count-done
    )
))

                 
                 
; BUT i don't really feel like making any test data...
; oh (sols): if you're gonna use built-in primitives (car), (cdr), (pair?), (null?), just PASS IN a tree.

(define (test-5.21)
    (load "ch5-regsim.scm")
    
    (let (  (machine-a (make-count-machine-5.21a))
            (machine-b (make-count-machine-5.21b))
            (tree '(a (b c (d)) (e f) g)) ; meteorgan's test data
            )
        (set-register-contents! machine-a 'tree tree)
        (start machine-a)
        (display "\nRecursive simulation: ")
        (display (get-register-contents machine-a 'count))
        (display "\nScheme: ")
        (display (count-leaves tree))
        (newline)
        
        (set-register-contents! machine-b 'tree tree)
        (start machine-b)
        (display "\nExplicit simulation: ")
        (display (get-register-contents machine-b 'retval))
        (display "\nScheme: ")
        (display (count-leaves-explicit tree))
        (newline)
    )
)
(test-5.21)
        