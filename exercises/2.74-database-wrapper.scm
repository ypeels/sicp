; This exercise has more in common with the complex number representations than with the previous exercise.
; Each division's file format can be considered a "type".
; Roadmap
; - implement a function lookup table
; - define a single API like (apply-generic that users can invoke on a file from any division
;
; and at the low level for each division's format
; - install functions in the table to satisfy the API spec


; something like this
; In (install-division-1: (put 'get-salary '(division-1-record) salary)
; In (get-salary: (apply-generic 'get-salary record)


; a.  Implement for headquarters a get-record procedure that retrieves a specified employee's record from a specified personnel file. 
;       The procedure should be applicable to any division's file. Explain how the individual divisions' files should be structured. 
;       In particular, what type information must be supplied?
(define (get-record file)
    (apply-generic 'get-record file))
    ; since we are using (apply-generic, file must satisfy
        ; (type-tag file) = 'division-1-file, etc.
        ; (contents file) = whatever file format division 1 uses; they must implement a procedure to return a record...?
        ; this 2-tiered approach feels wrong, somehow...


; b.  Implement for headquarters a get-salary procedure that returns the salary information from a given employee's record from 
;       any division's personnel file. How should the record be structured in order to make this operation work?
(define (get-salary record)
    (apply-generic 'get-salary record))
    ; Since we are using (apply-generic, record must satisfy 
        ; (type-tag record) = 'division-1-record, etc.
        ; (contents record) = internal format for division 1's procedures to handle
        
        
; c.  Implement for headquarters a find-employee-record procedure. 
;       This should search all the divisions' files for the record of a given employee and return the record. 
;       Assume that this procedure takes as arguments an employee's name and a list of all the divisions' files.
(define (find-employee-record name file-list)
    (filter                                                      ; extravagant, but it should work
        (lambda (record) (equal? name (name-record record)))     ; it's 2014 - why aren't you using a real database program?
        (flatmap get-record file-list)
    )
)


; d.  When Insatiable takes over a new company, what changes must be made in order to incorporate the new personnel information into the central system?
; implement more division-specific wrappers
; register those new divisions with the table
; ugly, but "additively" scalable (new addition doesn't disturb existing code base)


; see sols for alternatives