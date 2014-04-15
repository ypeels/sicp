(load "4.27-31-ch4-leval.scm")


; Exhibit a program that you would expect to run much more slowly without memoization than with memoization.
    ; well, memoization occurs when you evaluate a thunk
    ; so you just have to pass an argument to a function that takes a long time to evaluate, i think?
        ; (define (foo x) (loop 100000) x)
        ; (define y (foo 5))
        ; repeated requests for y will re-run the function? or maybe (foo (foo 5))?
        
; inspired by Exercise 4.27 (define triggers OUTERMOST function) and the example below.
(display "\nI had a whole pathological example planned out, but turns out that COUNTDOWN slows down by ~300 without memoization!? ")
(display "\n (define (countdown n) (if (> n 0) (countdown (- n 1)) 0)) ")
;(display "\n (define (id x) x)                                         ")
;(display "\n (define y (id (countdown 300)))                        ")
;(display "\n ; now repeated calls to y will retrigger the countdown if not memoized. How about making a million-long list of y's?")

    ; what??? well, if you add (display n) to countdown, you can watch the function slow down LATER into the recursion...
        ; does this have to do with implementing tail-recursion????
        ; or memoization of the body of countdown? but why would it slow down as n ticks down??
            ; or is env getting unmanageably large during recursion? 
                ; no, commenting out "garbage collection" in memoized (force-it) changes nothing
                
        ; http://eli.thegreenplace.net/2007/12/25/sicp-section-422/ 
        ; "Each time fact is called recursively, memoization saves the operation of obtaining the code from the call"
        ; i'm not sure this is the whole story, esp since to explain the dynamics (slower as recursion progresses?)
            ; if it were just code retrieval, EACH iteration should be equally slower...
        ; but i'm getting in way over my head here, as 4.28 illustrates...
        ; besides, this website's example isn't even tail-recursive... not that that should matter...?

;(define (loop n) (define (iter i) (if (< i n) (iter (+ i 1)) n)) (iter 0))
;;(define (foo x) (newline) (display x))
;(define x (loop 10000))
;(display x)
;(display x)
    
    


; from ch4-leval.scm
;; non-memoizing version of force-it

(define (force-it obj)
    ;(display "\nforce "); (user-print obj)
  (if (thunk? obj)
      (actual-value (thunk-exp obj) (thunk-env obj))                ; (actual-value) instead of (eval): force any nested thunks
      obj))
      
      
(display "\nfrom Exercise 4.27          ")
(display "\n(define count 0)            ")
(display "\n(define (id x)              ")
(display "\n  (set! count (+ count 1))  ")
(display "\n  x)                        ")

(display "\n from problem statement                           ")
(display "\n (define (square x)                               ")
(display "\n   (* x x))                                       ")
(display "\n                                                  ")
(display "\n ;;; L-Eval input:                                ")
(display "\n (square (id 10))                                 ")
(display "\n ;;; L-Eval value:                                ")
(display "\n <response> = 100, with and without memoization   ")
                                                                                                
(display "\n ;;; L-Eval input:                                                                  ")
(display "\n count                                                                              ")
(display "\n ;;; L-Eval value:                                                                  ")
(display "\n <response> = 1 memoized, 2 un-memoized.                                            ")
(display "\n                                                                                    ")
(display "\n Give the responses both when the evaluator memoizes and when it does not. [above]  ")

(append! primitive-procedures (list (list '< <)))
(append! primitive-procedures (list (list '> >)))
;(append! primitive-procedures (list (list 'not not)))
;(append! primitive-procedures (list (list 'eq? eq?)))
(define the-global-environment (setup-environment))
(driver-loop)

; the un-memoized result occurs because (id 10) is evaluated twice in (* (id 10) (id 10))
    ; the memoized process is "applicative-like" because it doesn't REALLY fully expand 
    ; but it's not like "REAL" memoization, since repeated calls to (id 10) DO increment count...
        ; remember the mechanism - the LOCAL COPY of (id 10) gets converted from 'thunk to 'evaluated-thunk
    