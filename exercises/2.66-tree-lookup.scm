; use chapter's tree structure
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

; generalize as desired
(define (make-record key . args)
    (append (list key) args))
(define (key-record record)
    (car record))

; built on (element-of-set? technology.
; a pretty trivial modification; not gonna check it...
(define (lookup-in-tree search-key tree)
    (if (null? tree)
        false
        (let ((current-key (key-record (entry tree))))
            (cond 
                ((= search-key current-key)
                    (entry tree))
                ((< search-key current-key)
                    (lookup-in-tree search-key (left-branch tree)))
                (else
                    (lookup-in-tree search-key (right-branch tree)))
            )
        )
    )
)
