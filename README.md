# vortex-simulation

## Welcome to the vortex-simulation project !

This repo is the result of a practical work supervised by Prof. Marc Fermigier during my studies at ESPCI Paris.
The purpose of this practical work was to study the formation of vortices by an obstacle using a two-dimensional finite element based mechanical flow simulation tool.

The software that was used to perform the simulation is called FreeFem++ (http://www3.freefem.org/) and was developed by a team of researchers from the Pierre and Marie Curie University (UPMC).

Computations are performed using dimensionless quantities. To do so, time was divided by the time needed for the fluid to go along the studied obstacle at average flow speed.
After running a few simulations, you can plot the following data with main.m : 

## Drag coefficient versus time 
![alt text](img/drag_coef_vs_time_3.png)

## Average drag coefficient versus Reynolds number
![alt text](img/avg_drag_coef.png)

## Main Result: vortex emission frequency

Vortex emission frequency is retrieved by measuring lift coefficient periodicity (FFT). 
![alt text](img/vortex_emission_freq.png)
We can notice that below a certain Reynolds threshold, the regime is aperiodic, which means that no vortex is emitted.
