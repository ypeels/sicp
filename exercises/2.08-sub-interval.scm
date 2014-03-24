; Using reasoning analogous to Alyssa's, describe how the difference of two intervals may be computed. 
;(define (sub-interval x y)
;    (let (  (p1 (- (lower-bound x) (lower-bound y)))
;            (p2 (- (lower-bound x) (upper-bound y)))
;            (p3 (- (upper-bound x) (lower-bound y)))
;            (p4 (- (upper-bound x) (upper-bound y))))
;        (make-interval (min p1 p2 p3 p4) (max (p1 p2 p3 p4)))
;    )
;)
;        
;
;    ; use 4 cases like mul-interval, cuz MAYBE there are NEGATIVE numbers here...
;    ; ADDITION is the special case that doesn't need min/max testing...
    

; no, the reasoning above was wrong (figured this out in exercise 2.9...)

; consider intervals x = (lx, ux) and y = (ly, uy), and their difference (- x y)
; by construction, lx < ux and ly < uy
; then -uy < -ly. add ux or lx to both sides!
; ux-uy < ux-ly
; lx-uy < lx-ly < ux-ly since lx < ux
; therefore, max = ux-ly FOR ALL VALUES. 
    ; (you can also see this graphically. don't get confused between displacement and distance [magnitude]!)
; the candidates for the min are (ux-uy) and (lx-uy).
    ; but lx < ux by construction!
; therefore, min = lx-uy FOR ALL VALUES!



;(define (sub-interval x y)
;    (make-interval 
;        (- (upper-bound x) (lower-bound y))
;        (- (lower-bound x) (upper-bound y))))
        
        
; alternatively, just implement subtraction in terms of addition, and therefore the answer MUST be unique!!!!!
    ; why bother thinking about things?
    
(define (sub-interval x y)
    (add-interval
        x
        (make-interval 
            (- 0 (upper-bound y))       ; we have to be more careful than alyssa in (div), since (add) does no checking!
            (- 0 (lower-bound y)))))
        