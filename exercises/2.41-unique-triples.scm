(load "2.40-unique-pairs.scm")

; k > i > j
; this is due to the unfortunate convention used in (prime-sum-pairs)
(define (unique-triples-with-k k)

    (define (triple-with-k pair)    ; analagous to (pair-with-i)
        (cons k pair))
        
    (map 
        triple-with-k
        (unique-pairs (- k 1))      ; ahhhh now isn't that clean!?
    )
)




; (display (unique-triples-with-k 5)); brief testing


(define (unique-triples n)

    ;(map
    (flatmap                        ; the (accumulate) in (flatmap) has the side effect of removing any ()'s from the list
        unique-triples-with-k
        (enumerate-interval 1 n)
    )
)

; (display (unique-triples 5))




(define (unique-triples-with-sum n s)   ; now THIS is crystal clear to me!!!
    (define (sum seq)
        (accumulate + 0 seq))
        
    (define (sums-to-s? seq)
        (= s (sum seq)))        

    (filter
        sums-to-s?
        (unique-triples n)
    )
)



(define (test-2.41)
    (display (unique-triples-with-sum 10 21))
)

; (test-2.41)
        