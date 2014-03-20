(load "1.24-25-fast-prime-by-fermat.scm")

; oh you lazy lazy Alyssa P. Hacker


; from ch1.scm
;; Logarithmic iteration
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))

  

  
; override the default expmod for this exercise
(define (expmod base exp m)
  (remainder (fast-expt base exp) m))
  
  
(define (f n) (fast-prime? n 100))
  
; call stuff like this on the command line
; (fast-prime? 10000000019 100)
; (f 10000019)
; HANGS on (f 100001). actually, it's just SLOW... scheme looks like it has infinite precision in principle...
    ; a^n gets ridiculously big, and even if you have infinite precision, your registers do NOT, so 
        ; so even if there is no truncation error, operations on a^n still get EXPONENTIALLY SLOWER as n increases