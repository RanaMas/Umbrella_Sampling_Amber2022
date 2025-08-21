# Umbrella-Sampling-using-Amber
Umbrella Sampling Setup using **Distance** or **Dihedral Angle** restraints using Amber 2022 and a Python code for PMF analysis is provided (can be also done using WHAM).

You will need to minimize, equilibrate and relax the system at defined parameters before initiating Umbrella sampling (short classical MD production run with no restraints). Then you will need to calculate the initial coordinates between the ligand and the anchor residue (can be an atom in each or COM distance between them).


Based on the initial coordinates and your simulation purposes, edit the starting parameters in the perl files. Here, we are running ligand unbinding using distance restraints (an example file of dihedral angle restraint is also provided).


How to run:

**Step 1:** perl generate_inputs.perl

#This will create all input files needed for min, equil. and production steps for each distance/dihedral window. Here the restraind goes from 6Å to 30Å in intervals of 0.5Å

**Step 2:** sh run.sh

#This initiates the simulations

**Step 2:** perl create_meta.perl

#After the simulations are done, this will generate the distance files needed to be processed by WHAM or the Python code provided


**Step 3:** python PMF-calc_and_plot.py

#Make sure to revise all parameters if used a force constant different than 400 kcal/(mol·Å²)
