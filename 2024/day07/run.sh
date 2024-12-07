#!/bin/sh
nvcc part1+2.cu -DPART1 -o part1
nvcc part1+2.cu -DPART2 -o part2
./part1
./part2
