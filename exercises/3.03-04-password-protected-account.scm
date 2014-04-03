; this seems VAGUELY familiar from CS 1...

; starting from from ch3.scm
(define (make-account balance saved-password)               ; Exercise 3.3: added second argument
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
    
  (define (call-the-cops)
    (error "119"))
    
    ; ugh, SO awkward that new state variables have to WRAP all the code...
  (let ((count 0))                                          ; Exercise 3.4: added incorrect password count and logic
    
      (define (dispatch password m)                         ; Exercise 3.3: added password argument and logic
        (if (eq? password saved-password)
            (begin
                (set! count 0)
                (cond ((eq? m 'withdraw) withdraw)
                      ((eq? m 'deposit) deposit)
                      (else (error "Unknown request -- MAKE-ACCOUNT"
                                   m)))
            )                
            (begin
                (set! count (+ count 1))
                (if (> count 7)                             ; added for Exercise 3.4
                    (call-the-cops)
                    (lambda (x) "Incorrect password")
                )
            )
        )
      )
      
      dispatch
  )
)
  
  
; test code from Exercise 3.3 problem statement
(define acc (make-account 100 'secret-password))
(newline) (display ((acc 'secret-password 'withdraw) 40))     ; 60
(newline) (display ((acc 'some-other-password 'deposit) 50))  ; "Incorrect password"
(newline) (display ((acc 'secret-password 'withdraw) 40))     ; 20, and resets incorrect password count


(define (f) ((acc 'wrong-password 'deposit) 50))
(f) (f) (f) (f) (f) (f) (f)
(display "\nand now one more to trigger the lockout")
(f)


