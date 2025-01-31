#!/bin/bash

case "$1" in
  1)
    mpirun -np 4 ./simulation_model.bin -np 1 python evaluation_software.py
    ;;
  2)
    mpirun -np 4 ./simulation_model_2.bin : -np 1 python evaluation_software.py
esac
