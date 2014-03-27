; extracts common structure in (right-split) and (up-split) exercise 2.44


(define (split attach-dir split-dir)
    (lambda (painter n)
        (if (= 0 n)
            painter
            (let ((smaller ((split attach-dir split-dir) painter (- n 1))))
                (attach-dir painter (split-dir smaller smaller)))))) 
                
; caught a parens error from http://community.schemewiki.org/?sicp-ex-2.45
; but it's otherwise the same code