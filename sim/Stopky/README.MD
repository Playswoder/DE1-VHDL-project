
# Stopky
This block acts as a stopwatch with MM:SS:CS output logic vectors

![Internal diagram PDF](img/Schematic.pdf)


![Source file](../../src/stopky.vhd)
![TB file](tb_stopky.vhd)
## Simulation results
In this simulation stopwatch start counting correctly
![image](img/tb_stopky_start.png)

In this simulation individual counters correctly stop at their supposed values
![image](img/tb_stopky_over.png)