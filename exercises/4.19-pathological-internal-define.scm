(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (display (f 10)))

(define (test-4.19)

    (define (test)

        ; from text
        (let ((a 1))
          (define (f x)
            (define b (+ a x))
            (define a 5)
            (+ a b))
          (f 10))
    )
    
    (newline) (display (test))
)
(test-4.19)



; Which (if any) of these viewpoints do you support? 
; Can you devise a way to implement internal definitions so that they behave as Eva prefers?
  
  ; first run this in mit-scheme
    ; Premature reference to reserved name: a
    
  ; then implement let and run in M-Eval
    ; had to go back and debug let from Exercise 4.6
    ; 16, which is Ben's value, which you'd expect from the basic sequential parsing in the metacircular evaluator.
    
    
; As an imperative programmer through and through, with ~10 years of regular C++ coding now, 
    ; I personally PREFER Ben's view, reading the code snippet sequentially.
    
; Alyssa's motivation is defensible, however... 
    ; simultaneous scoping is a RULE for internal defines that accomodates mutual recursion "intentionally".
    ; as a RULE, it should apply to all internal defines, not just procedures
    
; i am more in favor of the OUTCOME of Alyssa's implementation than Eva's
    ; basically, you have ambiguous code, which should raise an error instead of possibly evaluating in an unexpected way
    
; but logically, i GUESS i'd support eva over alyssa, since alyssa's view is restricted to a particular IMPLEMENTATION of simul scoping
    ; in particular, if you (perversely?) executed the (set!) statements in REVERSE order, eva's 20 results.    

; the book seems to give away the answer [that the authors prefer] in the footnote...    
    
; notice how C sidesteps such stupid issues completely by introducing function prototypes.
; C++ adds further flexibility by allowing function overloading and variable argument lists.
; are such stupid issues inevitable in weakly typed languages??

  
  ; seems like eva needs to do multiple passes, with potentially nontrivial logic
    ; what if you had b(a, c), a, c(a)? then you couldn't just read in reverse order
    ; you would have to scan through to see if any values could be bound immediately
    ; then scan again, to see what new bindings this enabled, etc.
    ; Footnote 26: "it seems difficult to implement a general, efficient mechanism that does what Eva requires."
    
    ; sols: "Lazy evaluation." - is that REALLY all it would take??