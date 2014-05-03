#!/bin/bash

checkExists() {
    if [ ! -e "$1" ]; then #&& ![ -d "$1"] ]; then - how do you do compound conditions? meh
        echo ERROR from shell.sh: $1 not found
        pause
        exit 1
    fi
}

targets=symlink-targets.txt
checkExists $targets

# http://www.bashguru.com/2010/05/how-to-read-file-line-by-line-in-shell.html
# http://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
# http://superuser.com/questions/194668/grep-to-find-files-that-contain-m-windows-carriage-return
# a surprising amount of hassle to do something supported directly by "for" in DOS
cat $targets | tr -d $'\r' | while read destDir destFile sourcePath; do 
    
    checkExists $destDir
    pushd $destDir > /dev/null
    
        checkExists $sourcePath    
        if [ -e $destFile ]; then
            echo asdf > /dev/null # echo Skipping $(pwd)/$destFile - already exists
        else
            #echo Want to link $sourcePath to $destFile
            ln -sv $sourcePath $destFile        
        fi
    
    popd > /dev/null
done

