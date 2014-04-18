(load "ch4-ambeval.scm")

(define analyze-ambeval analyze)
(define (analyze-4.54 expr)
    ;(display "\nanalyze-4.54\n")
    (if (require? expr)
        (begin
            ;(display "calling analyze-require")    ; only gets displayed during the initial analysis, NOT backtracking!
            (analyze-require expr)            
        )
            
        (analyze-ambeval expr)
    )
)

; from problem statement
(define (require? expr) (tagged-list? expr 'require))
(define (require-predicate expr) (cadr expr))


; skeleton from problem statement. this whole set of exercises was uncharacteristically easy... the calm before the storm of section 4.4?
(define (analyze-require expr)
    ;(display "\ncustom require!\n")                ; only gets displayed during the initial analysis, NOT backtracking!
  (let ((pproc (analyze (require-predicate expr))))
    (lambda (env succeed fail)
      (pproc env                                    ; first try the predicate value (it might fail)
             (lambda (pred-value fail2)             
                ;(display "\ncustom require passed")    ; gets called on EVERY successful (require)            
               (if (not pred-value) ;<??>           ; negated because they have (succeed) as the SECOND clause
                   (fail2) ;<??>                    ; cf. (analyze-assignment). meteorgan's sol incorrectly has fail2 instead of (fail2)
                   (succeed 'ok fail2)))            ; they handled the AMBIGUOUS return value for us.
             fail))))
             
             
(define (test-4.54)
    (load "4.35-an-integer-between-by-amb.scm")
    (install-integer-between)
    
    (load "4.37-pythagorean-triples-v2.scm")
    (install-pythagorean-triple-between)
    
    (driver-loop)
    
    ; and didn't install require. let 'er run!
    ; 3 4 5
    ; 5 12 13
    ; 6 8 10
    ; 7 24 25. seems fine to me...
)
;(define analyze analyze-4.54) (test-4.54)