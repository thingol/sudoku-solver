#!/bin/bash

for class in $(echo "EASY MEDIUM HARD FIENDISH" | cut -d' ' -f1- - ); do
    echo -n "$class"
    for i in $(seq 0 9); do
        echo -n " $i"
        echo "==================================================================================" >> test/${class}.report
        sbcl --noinform --dynamic-space-size 4096 --load qnd-load.lisp  test/${class}.sudoku_puzzle 1 >> test/${class}.report
    done
    echo ""
done
        
