(load "5.33-38-compiling-to-file.scm")

; override - modified from ch5-compiler.scm
(define (preserving regs seq1 seq2)                       
  (if (null? regs)                                        
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
        ;(if (and (needs-register? seq2 first-reg)          ; <===== no more "smartness"
        ;         (modifies-register? seq1 first-reg))          ; ALWAYS preserve requested registers
            (preserving (cdr regs)                        
             (make-instruction-sequence                   
              (list-union (list first-reg)                
                          (registers-needed seq1))
              (list-difference (registers-modified seq1)  
                               (list first-reg))          
              (append `((save ,first-reg))                
                      (statements seq1)                   
                      `((restore ,first-reg))))           
             seq2)
        ;    (preserving (cdr regs) seq1 seq2)))))         
        )))
        
        
(define (compile-fact)
    (compile-to-file
        '(define (factorial n)
          (if (= n 1)
              1
              (* (factorial (- n 1)) n)))
        'val
        'next
        "5.37-factorial-with-unsmart-preserving.asm"
    )
)
(compile-fact)


; and here's the diff with 5.33: 35 extra push/pop pairs, or 70 extra lines! 
    ; in the original, there were only 6! 
    ; and the original PROGRAM was only ~80 lines long!
; 1,3d0
; <   (save continue)
; <   (save env)
; <   (save continue)
; 5d1
; <   (restore continue)
; 12,14d7
; <   (save continue)
; <   (save env)
; <   (save continue)
; 16,22d8
; <   (restore continue)
; <   (restore env)
; <   (restore continue)
; <   (save continue)
; <   (save proc)
; <   (save env)
; <   (save continue)
; 24d9
; <   (restore continue)
; 26,28d10
; <   (restore env)
; <   (save argl)
; <   (save continue)
; 30,31d11
; <   (restore continue)
; <   (restore argl)
; 33,34d12
; <   (restore proc)
; <   (restore continue)
; 42d19
; <   (save continue)
; 44d20
; <   (restore continue)
; 51d26
; <   (save continue)
; 53d27
; <   (restore continue)
; 56,58d29
; <   (save continue)
; <   (save env)
; <   (save continue)
; 60,62d30
; <   (restore continue)
; <   (restore env)
; <   (restore continue)
; 65,66d32
; <   (save env)
; <   (save continue)
; 68d33
; <   (restore continue)
; 70d34
; <   (restore env)
; 72,74d35
; <   (save continue)
; <   (save env)
; <   (save continue)
; 76,79d36
; <   (restore continue)
; <   (restore env)
; <   (restore continue)
; <   (save continue)
; 81,83d37
; <   (save continue)
; <   (save env)
; <   (save continue)
; 85,91d38
; <   (restore continue)
; <   (restore env)
; <   (restore continue)
; <   (save continue)
; <   (save proc)
; <   (save env)
; <   (save continue)
; 93d39
; <   (restore continue)
; 95,97d40
; <   (restore env)
; <   (save argl)
; <   (save continue)
; 99,100d41
; <   (restore continue)
; <   (restore argl)
; 102,103d42
; <   (restore proc)
; <   (restore continue)
; 111d49
; <   (save continue)
; 113d50
; <   (restore continue)
; 117d53
; <   (restore continue)
; 125d60
; <   (save continue)
; 127d61
; <   (restore continue)
; 139d72
; <   (save continue)
; 141d73
; <   (restore continue)
; 146d77
; <   (restore env)
; 149d79
; <   (restore continue)
