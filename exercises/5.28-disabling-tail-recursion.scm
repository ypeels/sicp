
;(load "5.26-29-eceval-batch.scm")
(load "5.26-tail-iterative-factorial-stack.scm")
(load "5.27-recursive-factorial-stack.scm")


; override, and exploit the fact that regsim will go to the FIRST label found!! (Exercise 5.8)
(append! eceval-prebatch-text-5.26-29
    '(
        ; the non-tail-recursive assembly code from 5.4.2, with exp replaced for expr
        ev-sequence
          (test (op no-more-exps?) (reg unev))
          (branch (label ev-sequence-end))
          (assign expr (op first-exp) (reg unev))    ; i normalied to expr
          (save unev)
          (save env)
          (assign continue (label ev-sequence-continue))
          (goto (label eval-dispatch))
        ev-sequence-continue
          (restore env)
          (restore unev)
          (assign unev (op rest-exps) (reg unev))
          (goto (label ev-sequence))
        ev-sequence-end
          (restore continue)
          (goto (reg continue))
    )
)


(define eceval-prebatch-command eceval-prebatch-command-iterative-5.26) (run-eceval)
; n   total   max
; <1  33      14
; 1   70      17
; 2   107     20
; 3   144     23
; 4   181     26
; 9   366     41
; 10  403     44



;(define eceval-prebatch-command eceval-prebatch-command-recursive-5.27) (run-eceval)
; n   total   max
; 1   18      11
; 2   52      19
; 3   86      27
; 4   120     35
; 9   290     75
; 10  324     83

;              Maximum depth     Number of Pushes
; ----------|-----------------|-------------------
; Recursive |    8n + 3       |     34n - 16       Note that the constant term didn't change from 5.27
; factorial |                 |                    Slope increased by 3 and 2, respectively
; ----------|-----------------|-------------------
; Iterative |    3n + 14      |     37n + 33       Constant term increased by 4
; factorial |                 |                    Slope increased by 3 and 2, respectively (haha)