@echo off

rem mklink requires Administrator privileges, but then cmd starts in C:\Windows\system32
set SICP_ROOT=F:\Users\Jonathan\Documents\Qt\Projects-vc2008\sicp
call :checkExists "%SICP_ROOT%"
cd /d "%SICP_ROOT%"

set TARGETS=symlink-targets.txt
call :checkExists "%TARGETS%"

setlocal enabledelayedexpansion
for /f "tokens=1-3" %%i in (%TARGETS%) do (
    pushd %%i
    set TARGET_FILE=%%k
    
    rem http://www.computing.net/answers/programming/batch-file-replace-forward-slash/15589.html
    call :makeSymlink %%j !TARGET_FILE:/=\!
    
    popd
)

pause
exit /b



:makeSymlink
    call :checkExists %2    
    if not exist %1 (
        mklink %1 %2
    ) else (
        rem echo Skipping %CD%\%1 - already exists! 
    )
    rem echo "Want to create link %1 ==> %2"
exit /b



:checkExists
    if not exist %1 (
        echo Error - file not found: %1
        pause
        exit
    )
exit /b