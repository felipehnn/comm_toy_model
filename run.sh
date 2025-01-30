#!/bin/bash

mpirun -np 4 ./simulation_model : -np 1 python evaluation_software.py
