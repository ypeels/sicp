(load "4.35-an-integer-between-by-amb.scm")

(ambeval-batch
    '(define (a-pythagorean-triple-between low high)
      (let ((i (an-integer-between low high))
            (hsq (* high high)))
        (let ((j (an-integer-between i high)))          ; low <= i <= j <= high
          (let ((ksq (+ (* i i) (* j j))))              ; NO search in k!
            (require (>= hsq ksq))
            (let ((k (sqrt ksq)))
              (require (integer? k))
              (list i j k))))))
              
    '(define (t) (a-pythagorean-triple-between 11 100))
)   
(driver-loop)
              
; this is a doubly-nested search instead of triply-nested!
; as long as sqrt isn't as slow as an entire loop in k, then this should be faster!!

; FEELS faster than 4.36
; 3 4 5
; 5 12 13
; 6 8 10
; 7 24 25
; 8 15 17
; 9 12 15
; 9 40 41 - this one is ordered in I now
; 10 24 26
; 11 60 61 - wow, this one works!
; 12 16 20
; 12 35 37
; 13 84 85
; 14 48 50
; 15 20 25
; 15 36 39
; 16 30 34
; etc.
