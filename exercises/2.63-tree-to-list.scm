; from problem statement
(define (tree->list-1 tree)
  (if (null? tree)
      '()                                                       ; bottom-up (recursive popping up)
      (append (tree->list-1 (left-branch tree))                 ; 1. left
              (cons (entry tree)                                ; 2. current
                    (tree->list-1 (right-branch tree))))))      ; 3. right
(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list                                             ; top-down (iterative percolating down)
        (copy-to-list (left-branch tree)                        ; 3. left
                      (cons (entry tree)                        ; 1. current
                            (copy-to-list (right-branch tree)   ; 2. right
                                          result-list)))))
  (copy-to-list tree '()))
  
  