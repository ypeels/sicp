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


