; from ch3.scm
(define (display-line x)
  (newline)
  (display x))
  
(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))  
  
; from problem statement
(define (show x)
  (display-line x)
  x)
  

(define x (stream-map show (stream-enumerate-interval 0 10)))
; 0                 ; (stream-car) == (car), and first element of a stream always gets evaluated

;(stream-ref x 5)
; 1
; 2
; 3
; 4
; 5                 ; (show) gets applied LAZILY, and only once
;Value: 5

;(stream-ref x 7)
; 6
; 7
;Value: 7