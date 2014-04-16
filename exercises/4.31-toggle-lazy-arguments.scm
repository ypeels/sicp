; the problem calls this "an upward-compatible extension", i.e., forward-compatible.
; but don't they really mean BACKWARDS compatible??

; looks like if you maintain the argument list unmodified, you can "lazily" procrastinate handling it until (apply)
    ; compound procedure case
    ; parse the arguments here into a result list, before calling (extend-environment)
    
    ; but what about handling memoization? probably just tweak the tags and add an extra conditional to (force-it)