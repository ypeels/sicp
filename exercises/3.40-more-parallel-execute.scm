(load "3.39-42-parallel-execute-and-serializer.scm")


; from problem statement
(define x 10)

(parallel-execute (lambda () (set! x (* x x)))      ; P1
                  (lambda () (set! x (* x x x))))   ; P2
                  
                  
; changed x to y so i can run both tests together
(define y 10)

(define s (make-serializer))

(parallel-execute (s (lambda () (set! y (* y y))))
                  (s (lambda () (set! y (* y y y)))))
                  
; (newline) (display x) ; 10
; (newline) (display y) ; 10


; empirical results from interactive prompt
; x: 1000000
; y: 1000000

; theoretical possibilities for y
; 1000000 ONLY: since (z**a)**b = z**(a*b) and multiplication is commutative

; theoretical possibilities for x
; 1000000, of course
; 100000 = 10*100*100 - P1 overwrites x between first and second read of P2
; 10000 = 10*10*100
; 1000 = 10*10*10 - P2 overwrites P1 completely
; 100 = 10*10 - P1 overwrites P2 completely
; 10000 = 10*1000 - can also occur if P2 overwrites x between first and second read of P1

; anyway, since it's all multiplication, 
    ; there's no way you can get lower than 100 
    ; there's no way you can get higher than 100**3 or 1000**2
    ; there's no way you can get anything other than a power of 10
