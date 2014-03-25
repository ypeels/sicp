(display (list 1 (list 2 (list 3 4))))      ; (1 (2 (3 4)))


; box-pointer structure
; [1, -]-->[|, X]
;           |
;           V
;          [2, -]-->[|, X]
;                    |
;                    V
;                   [3, -]-->[4, X]