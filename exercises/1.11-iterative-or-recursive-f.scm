; (x, y, z) = (n-3, n-2, n-1)th entries
(define (f-next x y z)  (+  (* 3 z) (* 2 y) x))
    
        
        

(define (f-recursive n)
    (define (f n)       ; ahh lexical scoping finally pays off
        (if (< n 3) 
            n
            (f-next
                (f (- n 3))
                (f (- n 2))
                (f (- n 1)))))
            
            ;(+  (* 1 (f (- n 1)))     ; eat the extra multiplication for clarity
            ;    (* 2 (f (- n 2)))
            ;    (* 3 (f (- n 3))))))
    (f n))
    

; iterative PROCESS that uses tail recursion, because wtf knows how to write a for loop in scheme...
(define (f-iterative n)
        
    (define (iter x y z i)  
        (if (= i n)
            x               ; aha, just keep the last 3 entries on a rolling basis, like the iterative Fibonacci process
            (iter y z (f-next x y z) (+ i 1))))
    
    (if (< n 3)
        n
        (iter 0 1 2 0)))
        
        
(define (check n) (/ (f-recursive n) (f-iterative n)))
        
; i mean, it's KIND of interesting to learn such a fucked up and restrictive language...
; but i'd rather be spending brainpower on thinking about my CODE ITSELF than the language itself...

; Code Complete Section 17.2
; In general, recursion leads to small code and slow execution and chews up stack space. 
    ; [stack space NOT consumed for tail-recursive processes...but who has the time...]
; For a small group of problems, recursion can produce simple, elegant solutions. 
; For a slightly larger group of problems, it can produce simple, elegant, hard-to-understand solutions. 
; For most problems, it produces massively complicated solutions