; section 3.2.1 footnote 13: oh yeah, you can use define to modify values... but only in CURRENT scope
(define balance-define 0)
(define deposit-define 
    (let ((balance 0))
        (lambda (amt)
            (begin
                ;(define balance (+ balance amt))    ; 1. local define would SHADOWS the state variable!
                ;balance                            ; 2. "compile-time" error: Premature reference to reserved name
                ;(define balance-define (+ balance-define amt)) ; same error - even ignoring scoping, define != set!
                ;balance-define
                amt
            )
        )
    )
)


; The environment model of procedure application can be summarized by two rules [emphasis added]:
    
    ; A procedure object is applied to a set of arguments by constructing a frame, 
    ; binding the formal parameters of the procedure to the arguments of the call, 
    ; and then evaluating the body of the procedure in the context of the new environment constructed. 
    ; The new frame has as its enclosing environment ***the environment part of the procedure object being applied***.

    ; A procedure is created by evaluating a lambda expression relative to a given environment. 
    ; The resulting procedure object is a pair consisting of the text of the lambda expression 
    ; and a pointer to the environment ***in which the procedure was created***. 
    
    
; as a result, in Figure 3.5 p. 242, the enclosing environment of E2 is the global env, NOT E1!!
    ; this is because (sum-of-squares, which is being evaluated in E2, was created in GLOBAL scope
; " Notice that each frame created by square points to the global environment, 
; since this is the environment indicated by the square procedure object."

; "After the subexpressions are evaluated, the results are returned. ...
; Since our focus here is on the environment structures, we will not dwell on how these returned values are 
; passed from call to call; however, this is also an important aspect of the evaluation process, 
; and we will return to it in detail in chapter 5. " \
; Way to push that stack...