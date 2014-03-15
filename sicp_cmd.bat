@echo off

echo Adding MIT-Scheme (!?) to the path
set SCHEME_ROOT=C:\Program Files (x86)\MIT-GNU Scheme

rem wtf is a band? why do they make stupid scheme so hard to use??
rem set MITSCHEME_BAND=%SCHEME_ROOT%\lib\all.com

rem this works too, instead of setting MITSCHEME_BAND
set MITSCHEME_LIBRARY_PATH=%SCHEME_ROOT%\lib

rem Add current directory so i can just run (load filename)? doesn't work...
rem set MITSCHEME_LIBRARY_PATH=%MITSCHEME_LIBRARY_PATH%;%CD%

rem lets you just type "mit-scheme" to enter interactive interpreter
set PATH=%PATH%;%SCHEME_ROOT%\bin

rem shortcut for mit-scheme.exe --edit
doskey edwin="%SCHEME_ROOT%\bin\mit-scheme.exe" --edit

rem shortcut for running scheme files from command line, like any normal human would expect
doskey scheme="%SCHEME_ROOT%\bin\mit-scheme.exe" --load $1


rem more "destructive" than setting MITSCHEME_BAND
rem doskey mit-scheme="%SCHEME_ROOT%\bin\mit-scheme.exe" --band "%SCHEME_ROOT%\lib\all.com"




rem sets up the rest of my usual cli
set QT_HOME=C:\Progra~2\QtSDK1.1\Desktop\Qt\4.7.3\msvc2008\bin\qtenv2.bat
set QT_WORK=C:\Progra~2\Qt\QtSDK1.1\Desktop\Qt\4.7.3\msvc2008\bin\qtenv2.bat
if exist %QT_HOME% (
	C:\Windows\System32\cmd.exe /A /Q /K %QT_HOME%
) else (
	C:\Windows\System32\cmd.exe /A /Q /K %QT_WORK%
)