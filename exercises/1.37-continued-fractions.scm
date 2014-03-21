
; 1.37a: the obvious approach is recursive...
(define (cont-frac n d K)
    (define (iter i)    ; not QUITE sure how to do this without using an additional counter...
        (if (> i K) 
            0
            (/ (n i) (+ (d i) (iter (+ i 1))))))
    (iter 1))
    
    
    
; testing code
(define (test-1.37)

    
    (define (golden-ratio k) 
        (cont-frac
            (lambda (i) 1.)
            (lambda (i) 1.)
            k))
    
    (define (test-golden-ratio k)
        (display "\nk = ")
        (display k)
        (display ": ")
        (display (golden-ratio k)))
        
    (display "\nexact = ")
    (display (/ 2 (+ 1 (sqrt 5))))  ; .6180339887498948    
    (test-golden-ratio 8)               
    (test-golden-ratio 9)           ; .6181818181818182
    (test-golden-ratio 10)          ; .6179775280898876 - accurate to 4 decimal places.
    (test-golden-ratio 50)          ; .6180339887498948 - converged to display accuracy!!
    "goodbye world"
)


        
        
; run test code
(test-1.37)