; 2.4.2 seemed like a REALLY crude (and outdated?) way to retrofit runtime type checking onto a weakly typed language...

; 2.4.3 does a LITTLE better... but it uses some table entity that must be accessible to all tables...
    ; they've deferred how they implement this table until Section 3.3.3, when you've long forgotten about it...
    ; and how do you enforce scoping for (get and (put??

; """
;  To implement this plan, assume that we have two procedures, put and get, for manipulating the operation-and-type table:
; 
;     (put <op> <type> <item>)
;     installs the <item> in the table, indexed by the <op> and the <type>.
; 
;     (get <op> <type>)
;     looks up the <op>, <type> entry in the table and returns the item found there. If no item is found, get returns false. 
; 
; For now, we can assume that put and get are included in our language. [They are really not.]
; In chapter 3 (section 3.3.3, exercise 3.24) we will see how to implement these and other operations for manipulating tables.
; """

; of course, this means we can't TEST the stupid code they're making us trudge through
    

; let's make some sense of some of this syntax, using function signatures (which, notably, are NOT part of the code)
; (put 'magnitude '(polar) magnitude)
    ; op = 'magnitude
    ; type = '(polar)
    ; item = magnitude = (lambda (z) (car z))
; footnote 45: type is a list of the types of all arguments; i.e., void magnitude(polar z)
    ; congratulations, you've basically retrofitted C function prototypes onto your horrible language...
    ; it's a LIST so that you have the same API for one and multiple arguments in your prototype
; footnote 46: "a constructor is always used to make an object of one particular type. "
    ; but the rect and polar constructors take multiple arguments. are these untyped?
        ; apparently so, from their invocation: ((get 'make-from-real-imag 'rectangular) x y)
    ; it's their RETURN value that is a single type
        ; therefore the <type> argument of (put is used INCONSISTENTLY!?!?
            ; used for return type of constructor
            ; used for argument types for all other functions
            
;  (put 'make-from-mag-ang 'polar 
;       (lambda (r a) (tag (make-from-mag-ang r a))))
    ; (tag attaches type information, i.e., it returns (cons type object)
    ; this gets parsed/stripped in (apply-generic by (type-tag.



        
; i THOUGHT (apply was just syntactic sugar...
; "Apply applies the procedure, using the elements in the list as arguments."

(newline)
(display (apply + (list 1 2 3 4)))      ; 10
    ; but once i actually pasted the code in, i realized it UNPACKS THE LIST and passes it as arguments!!

; also, a quick look at the index shows that there are "lazy" and "metacircular" flavors of (apply to come...
; it is, after all, one of the three "top-billed" cast members in the cover illustration (eval, apply, lambda)
    ; it's story can't possibly end right here...
    
    
    
; other notes
    ; (attach-tag, (type-tag, and (contents were defined in 2.4.2, remember?

    ; the trailing 'done in (install-rectangular-package and (install-polar-package is their UNUSED RETURN VALUE
        ; it has NOTHING to do with the fabled get/put table.

        
; oh WAIT - (get and (put are implemented in ch2support.scm!!




; ch2.scm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;SECTION 2.4.2

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))


;;;SECTION 2.4.3

;; uses get/put (from 3.3.3) -- see ch2support.scm

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a) 
    (cons (* r (cos a)) (* r (sin a))))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y) 
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

;;footnote
;: (apply + (list 1 2 3 4))


(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

;; Generic selectors

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))


;; Constructors for complex numbers

(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rectangular) x y))

(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'polar) r a))

; ch2support.scm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;-----------
;;;from section 3.3.3 for section 2.4.3
;;; to support operation/type table for data-directed dispatch

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

;;;-----------




; and finally some testing code from me...
(install-rectangular-package) ; don't forget! otherwise "the object #f is not applicable"
(install-polar-package)

; the resulting operations are pretty easy for the end-user, though
(define z1 (make-from-real-imag 1 1))
(define z2 (make-from-mag-ang 2 0)) 
(newline) (display (magnitude z1))
(newline) (display (imag-part z2))
