; element-of-set? - doesn't TECHNICALLY need to change...
; but NONE of the other functions technically needs to change since the "no duplicates allowed" repn
; would work fine given a "duplicates allowed" constraint

(define (element-of-set? x set)
    (memq x set))               ; all values except #f (and false) are TRUE

(define (adjoin-set x set)
    (cons x set))               ; no checking for (element-of-set?)

;(define (intersection-set set1 set2)
;    (cond ((or (null? set1) (null? 
; i think intersection-set is UNCHANGED no matter WHAT you do

(define (union-set set1 set2)
    (append set1 set2))         ; no looping through; just slap them together!
    

; analysis
; (element-of-set?) will be slower in general, since the set repns will be large
    ; but it's still O(n) where n is now the # of items in the LIST, which may include duplicates
; (adjoin-set will have the same scaling as (cons - probably O(1)
; (union-set will have the same scaling as (append - probably O(1)? sol says O(n)
; (intersection-set will have the same scaling as before - O(n^2)
    ; since the sets are at least as large, the absolute time cost will be greater
    
    
; if your application has predominantly (adjoin and (union and very rarely calls (element-of, 
; this MAY be worth it
