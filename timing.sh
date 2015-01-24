#!/bin/bash

for class in $(echo "EASY MEDIUM HARD FIENDISH" | cut -d' ' -f1- - ); do
    echo -n "$class"
    for i in $(seq 0 9); do
        echo -n " $i"
        sbcl --no-inform --load qnd-load.lisp  test/${class}.sudoku_puzzle 45000 >> test/${class}.report
    done
    echo ""
done
        
