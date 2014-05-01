(load "5.26-29-eceval-batch.scm")

; modified from problem statement
(define (eceval-prebatch-command-fibonacci-5.29) 
    '(define (f n)
      (if (< n 2)
          n
          (+ (f (- n 1)) (f (- n 2)))))
)

(define eceval-prebatch-command eceval-prebatch-command-fibonacci-5.29) (run-eceval)

; n   total   max     Fib(n)    
; 0-1 16      8       0,1
; 2   72      13      1
; 3   128     18      2
; 4   240     23      3
; 5   408     28      5
; 6   688     33      8
; 7   1136    38      13
; 8   1864    43      21
; 9   3040    48      34
; 10  4944    53      55



; Empirically, of course (I ain't tracing through this...)

; a. Maximum depth of stack = 5n + 3
    ; hand-waving proof of linearity: 1.2.2 pp. 38-39
    
; b. "Give a formula for the total number of pushes used to compute Fib(n) for n > 2

; "Let S(n) be the number of pushes used in computing Fib(n). 
; "You should be able to argue that there is a formula that expresses S(n) in terms of 
; "S(n - 1), S(n - 2), and some fixed ``overhead'' constant k that is independent of n.

    ; handwaving argument
    ; Fib(n) = Fib(n-1) + Fib(n-2), not just mathematically, but HOW IT IS COMPUTED
        ; you'll incur S(n-1) and S(n-2) for each function evaluation on the right
        ; then there is some fixed overhead for computing the sum and returning
        
    ; k = 40. This was found empirically, from n = 2, 3, 4, and it holds up for the rest of my data!
        ; not sure how to prove this, though...
        
; "Then show that S(n) can be expressed as a Fib(n + 1) + b and give the values of a and b"
    ; also empirically, i guess, since i don't have a formula for total...
    
    ; lookit that, Fib(n) is linear for n = 2 to 4.

; n   Fib(n+1)    S(n)
; 2   2           72
; 3   3           128
; 
; This yields a = 56 and b = -40. Checks out for the rest of my data!
; 
; Not sure what is wrong with meteorgan's data... but for him, k = -b too.
    