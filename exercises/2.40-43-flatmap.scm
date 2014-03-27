; from ch2.scm
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))
      
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

  
; support code
(load "2.33-37-accumulate.scm")
(define nil ())



